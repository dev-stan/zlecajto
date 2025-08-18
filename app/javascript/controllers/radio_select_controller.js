import { Controller } from "@hotwired/stimulus"

// Adds/removes selected styling for custom radio button wrappers so they visually stay selected.
// Uses targets: input (actual radio) and display (styled span)
export default class extends Controller {
  static targets = ["input", "display"]

  connect() {
    // On connect ensure current state is reflected
    this.updateFromGroup()
  }

  change() {
    // When one changes, update all radios in same named group within the closest form/scope
    this.updateFromGroup(true)
  }

  updateFromGroup(triggerGroup = false) {
    const name = this.inputTarget.name
    // Find all radios with same name inside nearest form or document
    const root = this.element.closest('form') || document
    const radios = root.querySelectorAll(`input[type="radio"][name="${CSS.escape(name)}"]`)
    radios.forEach(radio => {
      const wrapper = radio.closest('[data-controller~="radio-select"]')
      if (!wrapper) return
      const display = wrapper.querySelector('[data-radio-select-target="display"]')
      if (!display) return
      display.classList.toggle('border-violet-500', radio.checked)
      display.classList.toggle('bg-violet-100', radio.checked)
      display.classList.toggle('text-violet-900', radio.checked)
      display.classList.toggle('shadow', radio.checked)
      // Remove possible previously peer-driven classes to avoid stale states when Turbo caches
      if (!radio.checked) {
        display.classList.remove('border-violet-500','bg-violet-100','text-violet-900','shadow')
      }
    })
  }
}
