
import { Controller } from "@hotwired/stimulus"

// Handles both single and multiple image uploads with preview
export default class extends Controller {
  static targets = ["input", "count", "list"]

  connect() {
    this.files = []
    this.limit = parseInt(this.data.get("limit"))
    this.updateCount()
    this.renderPreviews()
    this.updatePickButtonState()
  }

  pick() {
    if (this.limit && this.files.length >= this.limit) return
    if (this.hasInputTarget) {
      this.inputTarget.value = ''
      this.inputTarget.click()
    }
  }

  changed() {
    const input = this.inputTarget
    const isMultiple = input.multiple
    let selected = Array.from(input.files || [])
    if (isMultiple) {
      this.files = [...(this.files || []), ...selected]
      this.files = this.files.filter((f, i, arr) => arr.findIndex(x => x.name === f.name && x.size === f.size) === i)
      if (this.limit && this.files.length > this.limit) {
        this.files = this.files.slice(0, this.limit)
      }
      input.files = this._toFileList(this.files)
    } else {
      this.files = selected
    }
    this.updateCount()
    this.renderPreviews()
    this.updatePickButtonState()
  }

  updateCount() {
    if (!this.hasCountTarget) return
    const count = (this.files || []).length
    this.countTarget.textContent = this.limit && count > 0 ? `Wybrano ${count} / ${this.limit}` : ""
  }

  updatePickButtonState() {
    const pickBtn = this.element.querySelector('[data-action~="image-upload#pick"]')
    if (!pickBtn) return
    const disabled = this.limit && this.files.length >= this.limit
    pickBtn.disabled = !!disabled
    pickBtn.classList.toggle('opacity-50', disabled)
    pickBtn.classList.toggle('cursor-not-allowed', disabled)
  }

  renderPreviews() {
    this.listTarget.innerHTML = ''
    if (!this.files.length) return
    this.files.forEach((file, idx) => {
      if (!file.type.startsWith('image/')) return
      const reader = new FileReader()
      reader.onload = e => {
        const wrapper = document.createElement('div')
        wrapper.className = 'relative w-20 h-20 rounded-md overflow-hidden bg-gray-200 flex items-center justify-center group'
        const img = document.createElement('img')
        img.src = e.target.result
        img.alt = file.name
        img.className = 'absolute inset-0 w-full h-full object-cover'
        const removeBtn = this._buildRemoveBtn(idx)
        wrapper.append(img, removeBtn)
        this.listTarget.appendChild(wrapper)
      }
      reader.readAsDataURL(file)
    })
  }

  removeFile(idx) {
    this.files.splice(idx, 1)
    this.inputTarget.files = this._toFileList(this.files)
    this.updateCount()
    this.renderPreviews()
    this.updatePickButtonState()
  }

  disconnect() {
    this.element.removeEventListener('direct-upload:start', this.directUploadStartHandler)
    this.element.removeEventListener('direct-upload:complete', this.directUploadCompleteHandler)
  }

  _toFileList(files) {
    const dt = new DataTransfer()
    files.forEach(f => dt.items.add(f))
    return dt.files
  }

  _buildRemoveBtn(idx) {
    const btn = document.createElement('button')
    btn.type = 'button'
    btn.innerHTML = '&times;'
    btn.setAttribute('aria-label', 'Usuń zdjęcie')
    btn.className = 'absolute top-1 right-1 z-10 w-6 h-6 rounded-full bg-white bg-opacity-80 text-gray-700 hover:bg-red-500 hover:text-white flex items-center justify-center text-lg font-bold shadow transition-opacity opacity-0 group-hover:opacity-100 focus:opacity-100 focus:outline-none'
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
