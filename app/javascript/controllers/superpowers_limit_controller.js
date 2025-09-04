import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.updateCheckboxStates()
    this.element.addEventListener('change', this.updateCheckboxStates.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('change', this.updateCheckboxStates.bind(this))
  }

  updateCheckboxStates() {
    const checked = this.checkboxTargets.filter(cb => cb.checked)
    const limit = 3
    const overLimit = checked.length >= limit
    this.checkboxTargets.forEach(cb => {
      if (!cb.checked) {
        cb.disabled = overLimit
        cb.classList.toggle('border-red-500', overLimit)
        cb.classList.toggle('cursor-not-allowed', overLimit)
        cb.parentElement?.classList.toggle('opacity-50', overLimit)
      } else {
        cb.disabled = false
        cb.classList.remove('border-red-500', 'cursor-not-allowed')
        cb.parentElement?.classList.remove('opacity-50')
      }
    })
  }
}
