import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photos"
export default class extends Controller {
  static targets = ["input", "count", "list", "template"]

  connect() {
  this.files = []
    this.updateCount()
  }

  pick() {
    if (this.hasInputTarget) {
      // Reset before opening picker so selecting the same file twice still triggers change
      this.inputTarget.value = ''
      this.inputTarget.click()
    }
  }

  changed() {
  // Merge newly selected files with existing ones so the add button can be reused.
  const newlySelected = Array.from(this.inputTarget.files || [])
  this.files = (this.files || []).concat(newlySelected)
  // Rebuild FileList on the input so Rails submits all images (and let ActiveStorage direct uploads pick them up)
  const dataTransfer = new DataTransfer()
  this.files.forEach(f => dataTransfer.items.add(f))
  this.inputTarget.files = dataTransfer.files
  this.updateCount()
  this.renderPreviews()
  }

  updateCount() {
  if (!this.hasCountTarget) return
  const count = (this.files || []).length
  this.countTarget.textContent = count === 0 ? "" : `${count} selected`
  }

  renderPreviews() {
  if (!this.hasListTarget) return
  // Clear only preview container (listTarget now isolated from the add button)
  this.listTarget.innerHTML = ''
  if (!this.files.length) return
  (this.files || []).forEach((file) => {
      if (!file.type.match(/^image\//)) return
      const reader = new FileReader()
      reader.onload = (e) => {
        const wrapper = document.createElement('div')
        wrapper.className = 'relative w-20 h-20 rounded-md overflow-hidden bg-gray-200 flex items-center justify-center'
        const img = document.createElement('img')
        img.src = e.target.result
        img.alt = file.name
        img.className = 'absolute inset-0 w-full h-full object-cover'
        wrapper.appendChild(img)
        this.listTarget.appendChild(wrapper)
      }
      reader.readAsDataURL(file)
    })
  }
}
