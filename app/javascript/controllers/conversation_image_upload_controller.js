import { Controller } from "@hotwired/stimulus"

// Stimulus identifier: conversation-image-upload
// Responsibilities:
// - Let user pick images (via hidden file input)
// - Show a neat preview strip/grid above the chat input
// - Serialize selected images as base64 data URLs into a hidden <input>
// - Clear previews on custom event "conversation:sent"
export default class extends Controller {
  static targets = ["fileInput", "previews", "imagesField"]

  connect() {
    // Clean initial state
    this.clear()
    this.imagesData = []
    // Listen for the conversation-sent event to reset previews
    this.element.addEventListener("conversation:sent", () => this.clear())
  }

  chooseFiles() {
    this.fileInputTarget.click()
  }

  async fileChanged(event) {
    const files = Array.from(event.target.files || [])
    if (files.length === 0) return

    // Read files as data URLs
    const dataUrls = await Promise.all(files.map(this.readFileAsDataURL))
    this.imagesData = [...this.imagesData, ...dataUrls]

    // Update hidden field with JSON array
    this.imagesFieldTarget.value = JSON.stringify(this.imagesData)

    // Render previews
    this.renderPreviews()
  }

  renderPreviews() {
    this.previewsTarget.innerHTML = ""
    if (this.imagesData.length === 0) {
      this.previewsTarget.classList.add("hidden")
      return
    }
    this.previewsTarget.classList.remove("hidden")

    const grid = document.createElement("div")
    grid.className = `grid gap-2 ${this.imagesData.length > 2 ? 'grid-cols-4' : (this.imagesData.length > 1 ? 'grid-cols-2' : 'grid-cols-1')}`

    this.imagesData.forEach((src, idx) => {
      const wrapper = document.createElement("div")
      wrapper.className = "group relative overflow-hidden rounded-md border border-gray-200 bg-white aspect-square w-20 h-20"

      const img = document.createElement("img")
      img.src = src
      img.alt = "Podgląd"
      img.className = "object-cover w-full h-full transition-transform duration-200 group-hover:scale-105"

      const removeBtn = document.createElement("button")
      removeBtn.type = "button"
      removeBtn.innerHTML = '<i class="fa-solid fa-xmark" aria-hidden="true"></i>'
      removeBtn.setAttribute("aria-label", "Usuń zdjęcie")
      removeBtn.className = "absolute top-1 right-1 z-10 w-6 h-6 rounded-full bg-white/90 text-gray-700 hover:bg-red-500 hover:text-white flex items-center justify-center text-sm font-bold shadow focus:outline-none focus:ring-2 focus:ring-red-400"
      removeBtn.addEventListener("click", (e) => {
        e.preventDefault()
        this.removeImageAt(idx)
      })

      wrapper.append(img, removeBtn)
      grid.appendChild(wrapper)
    })

    this.previewsTarget.appendChild(grid)
  }

  clear() {
    if (this.hasImagesFieldTarget) this.imagesFieldTarget.value = ""
    if (this.hasPreviewsTarget) {
      this.previewsTarget.innerHTML = ""
      this.previewsTarget.classList.add("hidden")
    }
    if (this.hasFileInputTarget) this.fileInputTarget.value = ""
    this.imagesData = []
  }

  removeImageAt(index) {
    this.imagesData.splice(index, 1)
    this.imagesFieldTarget.value = JSON.stringify(this.imagesData)
    this.renderPreviews()
  }

  // Helpers
  readFileAsDataURL(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader()
      reader.onload = () => resolve(reader.result)
      reader.onerror = reject
      reader.readAsDataURL(file)
    })
  }
}
