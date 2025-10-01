

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "count", "list"]

  connect() {
    this.files = []
    this.limit = parseInt(this.data.get("limit"))
    this.updateCountDisplay()
    this.renderImagePreviews()
    this.updatePickButtonState()
  }

  disconnect() {
    this.element.removeEventListener('direct-upload:start', this.directUploadStartHandler)
    this.element.removeEventListener('direct-upload:complete', this.directUploadCompleteHandler)
  }

  pick() {
    if (this.isAtLimit()) return
    this.inputTarget.value = '' // Clear the file input's current value before opening the file picker
    this.inputTarget.click()
  }

  changed() {
    const input = this.inputTarget
    const selectedFiles = Array.from(input.files || [])
    if (input.multiple) {
      this.addFiles(selectedFiles)
      input.files = this.toFileList(this.files)
    } else {
      this.files = selectedFiles
    }
    this.refreshUI()
  }

  removeFile(idx) {
    this.files.splice(idx, 1)
    this.inputTarget.files = this.toFileList(this.files)
    this.refreshUI()
  }

  refreshUI() {
    this.updateCountDisplay()
    this.renderImagePreviews()
    this.updatePickButtonState()
  }

  updateCountDisplay() {
    if (!this.hasCountTarget) return
    const count = this.files.length
    this.countTarget.textContent = this.limit && count > 0 ? `Wybrano ${count} / ${this.limit}` : ""
  }

  updatePickButtonState() {
    const pickBtn = this.element.querySelector('[data-action~="image-upload#pick"]')
    if (!pickBtn) return
    const disabled = this.isAtLimit()
    pickBtn.disabled = disabled
    pickBtn.classList.toggle('opacity-50', disabled)
    pickBtn.classList.toggle('cursor-not-allowed', disabled)
  }

  renderImagePreviews() {
    this.listTarget.innerHTML = ''
    if (!this.files.length) return
    this.files.forEach((file, idx) => {
      if (!file.type.startsWith('image/')) return
      this.renderImagePreview(file, idx)
    })
  }

  renderImagePreview(file, idx) {
    const reader = new FileReader()
    reader.onload = e => {
      const wrapper = document.createElement('div')
      wrapper.className = 'relative w-20 h-20 rounded-md overflow-hidden bg-gray-200 flex items-center justify-center group'
      const img = document.createElement('img')
      img.src = e.target.result
      img.alt = file.name
      img.className = 'absolute inset-0 w-full h-full object-cover'
      const removeBtn = this.buildRemoveButton(idx)
      wrapper.append(img, removeBtn)
      this.listTarget.appendChild(wrapper)
    }
    reader.readAsDataURL(file)
  }

  addFiles(newFiles) {
    this.files = [...(this.files || []), ...newFiles] // Comibne existing and new files
    if (this.limit && this.files.length > this.limit) {
      this.files = this.files.slice(0, this.limit)
    }
  }

  isAtLimit() {
    return this.limit && this.files.length >= this.limit
  }

  toFileList(files) {
    const dt = new DataTransfer()
    files.forEach(f => dt.items.add(f))
    return dt.files
  }

  buildRemoveButton(idx) {
    const btn = document.createElement('button')
    btn.type = 'button'
    // Font Awesome close icon (fa-solid fa-xmark)
    btn.innerHTML = '<i class="fa-solid fa-xmark" aria-hidden="true"></i>'
    btn.setAttribute('aria-label', 'Usuń zdjęcie')
    // Always visible (was previously hidden until hover); mobile friendly larger tap target
    btn.className = 'absolute top-1 right-1 z-10 w-5 h-5 rounded-full bg-white/90 text-gray-700 text-center hover:bg-red-500 hover:text-white flex items-center justify-center text-md font-bold shadow focus:outline-none focus:ring-2 focus:ring-red-400 touch-manipulation'
      btn.style.display = 'flex'
      btn.style.alignItems = 'center'
      btn.style.justifyContent = 'center'
      btn.addEventListener('click', ev => {
        ev.preventDefault()
        this.removeFile(idx)
      })
    return btn
  }
}
