import { Controller } from "@hotwired/stimulus"

// Multi-select via radio UI: toggles checked state and renders hidden array inputs user[categories][]
export default class extends Controller {
  static targets = ["container"]

  connect() {
    // Initialize from currently checked inputs in the DOM
    const inputs = this._inputs()
    this.selected = new Set(Array.from(inputs).filter(i => i.checked).map(i => i.value))
    this._renderHidden()
  }

  toggle(event) {
    event.preventDefault()
    const wrapper = event.currentTarget
    let input = wrapper && wrapper.querySelector('input[type="radio"]')

    if (!input) {
      const label = event.target.closest('label')
      input = label && label.htmlFor ? document.getElementById(label.htmlFor) : null
    }
    if (!input) return

    const v = input.value
    if (this.selected.has(v)) {
      this.selected.delete(v)
      input.checked = false
    } else {
      this.selected.add(v)
      input.checked = true
    }

    this._renderHidden()
  }

  _renderHidden() {
    if (!this.hasContainerTarget) return
    // Clear and recreate hidden inputs for Rails array param submission
    this.containerTarget.innerHTML = ''
    this.selected.forEach(v => {
      const input = document.createElement('input')
      input.type = 'hidden'
      input.name = 'user[categories][]'
      input.value = v
      this.containerTarget.appendChild(input)
    })
  }

  _inputs() {
    return this.element.querySelectorAll('input[type="radio"]')
  }
}
