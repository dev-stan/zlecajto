import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

// Stimulus identifier: conversation-image-upload
export default class extends Controller {
  static targets = ["fileInput", "previews", "imagesField"]

  connect() {
    this.clear()
    this.attachments = []  // this will store blob_signed_ids
    this.element.addEventListener("conversation:sent", () => this.clear())
  }

  chooseFiles() {
    this.fileInputTarget.click()
  }

  async fileChanged(event) {
    const files = Array.from(event.target.files)
    if (files.length === 0) return

    for (const file of files) {
      const signedId = await this.directUploadFile(file)
      this.attachments.push({ signedId, file })
    }

    this.imagesFieldTarget.value = JSON.stringify(
      this.attachments.map(a => a.signedId)
    )

    this.renderPreviews()
  }

  async directUploadFile(file) {
    return new Promise((resolve, reject) => {
      const upload = new DirectUpload(
        file,
        "/rails/active_storage/direct_uploads"
      )

      upload.create((error, blob) => {
        if (error) reject(error)
        else resolve(blob.signed_id)
      })
    })
  }

  renderPreviews() {
    this.previewsTarget.innerHTML = ""
    if (this.attachments.length === 0) {
      this.previewsTarget.classList.add("hidden")
      return
    }

    this.previewsTarget.classList.remove("hidden")

    const grid = document.createElement("div")
    grid.className = `grid gap-2 ${this.attachments.length > 2 ? 'grid-cols-4' :
      (this.attachments.length > 1 ? 'grid-cols-2' : 'grid-cols-1')}`

    this.attachments.forEach((item, idx) => {
      const wrapper = document.createElement("div")
      wrapper.className = "group relative overflow-hidden rounded-md border bg-white aspect-square w-20 h-20"

      const img = document.createElement("img")
      img.src = URL.createObjectURL(item.file)
      img.className = "object-cover w-full h-full"

      const removeBtn = document.createElement("button")
      removeBtn.type = "button"
      removeBtn.innerHTML = '<i class="fa-solid fa-xmark"></i>'
      removeBtn.className = "absolute top-1 right-1 bg-white rounded-full w-6 h-6"
      removeBtn.addEventListener("click", (e) => {
        e.preventDefault()
        this.removeImageAt(idx)
      })

      wrapper.append(img, removeBtn)
      grid.appendChild(wrapper)
    })

    this.previewsTarget.appendChild(grid)
  }

  removeImageAt(index) {
    this.attachments.splice(index, 1)

    this.imagesFieldTarget.value = JSON.stringify(
      this.attachments.map(a => a.signedId)
    )

    this.renderPreviews()
  }

  clear() {
    if (this.hasPreviewsTarget) {
      this.previewsTarget.innerHTML = ""
      this.previewsTarget.classList.add("hidden")
    }
    this.fileInputTarget.value = ""
    this.attachments = []
    this.imagesFieldTarget.value = ""
  }
}
