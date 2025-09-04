import { Controller } from "@hotwired/stimulus"

// Handles both single and multiple image uploads with preview
export default class extends Controller {
  static targets = ["input", "count", "list"]

  connect() {
    this.files = []
    this.limit = this.data.get("limit") ? parseInt(this.data.get("limit"), 10) : null
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
      this.files = (this.files || []).concat(selected)
      // Remove duplicates by name+size
      this.files = this.files.filter((f, i, arr) => arr.findIndex(x => x.name === f.name && x.size === f.size) === i)
      if (this.limit && this.files.length > this.limit) {
        this.files = this.files.slice(0, this.limit)
      }
      // Rebuild FileList for Rails/ActiveStorage
      const dataTransfer = new DataTransfer()
      this.files.forEach(f => dataTransfer.items.add(f))
      input.files = dataTransfer.files
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
    if (this.limit) {
      this.countTarget.textContent = count === 0 ? "" : `Wybrano ${count} / ${this.limit}`
    } else {
      this.countTarget.textContent = ""
    }
  }

  updatePickButtonState() {
    const pickBtn = this.element.querySelector('[data-action~="image-upload#pick"]')
    if (!pickBtn) return
    if (this.limit && this.files.length >= this.limit) {
      pickBtn.disabled = true
      pickBtn.classList.add('opacity-50', 'cursor-not-allowed')
    } else {
      pickBtn.disabled = false
      pickBtn.classList.remove('opacity-50', 'cursor-not-allowed')
    }
  }

  renderPreviews() {
    if (!this.hasListTarget) return
    this.listTarget.innerHTML = ''
    if (!this.files.length) return
    (this.files || []).forEach((file, idx) => {
      if (!file.type.match(/^image\//)) return
      const reader = new FileReader()
      reader.onload = (e) => {
        const wrapper = document.createElement('div')
        wrapper.className = 'relative w-20 h-20 rounded-md overflow-hidden bg-gray-200 flex items-center justify-center group'
        const img = document.createElement('img')
        img.src = e.target.result
        img.alt = file.name
        img.className = 'absolute inset-0 w-full h-full object-cover'
        // Remove button
        const removeBtn = document.createElement('button')
        removeBtn.type = 'button'
        removeBtn.innerHTML = '&times;'
        removeBtn.setAttribute('aria-label', 'Usuń zdjęcie')
  removeBtn.className = 'absolute top-1 right-1 z-10 w-6 h-6 rounded-full bg-white bg-opacity-80 text-gray-700 hover:bg-red-500 hover:text-white flex items-center justify-center text-lg font-bold shadow transition-opacity opacity-0 group-hover:opacity-100 focus:opacity-100 focus:outline-none'
  removeBtn.style.display = 'flex'
  removeBtn.style.alignItems = 'center'
  removeBtn.style.justifyContent = 'center'
        removeBtn.addEventListener('click', (ev) => {
          ev.preventDefault()
          this.removeFile(idx)
        })
        wrapper.appendChild(img)
        wrapper.appendChild(removeBtn)
        this.listTarget.appendChild(wrapper)
      }
      reader.readAsDataURL(file)
    })
  }

  removeFile(idx) {
    this.files.splice(idx, 1)
    // Rebuild FileList for Rails/ActiveStorage
    const input = this.inputTarget
    const dataTransfer = new DataTransfer()
    this.files.forEach(f => dataTransfer.items.add(f))
    input.files = dataTransfer.files
    this.updateCount()
    this.renderPreviews()
    this.updatePickButtonState()
  }
}
