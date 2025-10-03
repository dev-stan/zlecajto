import { Controller } from "@hotwired/stimulus"

// Generic controller that ensures only the visible variant (radio group vs select)
// is enabled for submission. Assumes two targets: radios (wrapper containing radio inputs)
// and select (wrapper containing a single <select>). Hidden variant (display: none)
// gets all its form controls disabled so it won't override values with blanks.
export default class extends Controller {
  static targets = ["radios", "select"]

  connect() {
    this._boundUpdate = this.update.bind(this)
    this.update()
    window.addEventListener("resize", this._boundUpdate)
  }

  disconnect() {
    window.removeEventListener("resize", this._boundUpdate)
  }

  update() {
    const radiosVisible = this._isVisible(this.radiosTarget)
    const selectEl = this.selectTarget.querySelector('select')
    const radioInputs = this.radiosTarget.querySelectorAll('input[type="radio"]')

    if (radiosVisible) {
      // Enable radios, disable select
      radioInputs.forEach(r => r.disabled = false)
      if (selectEl) selectEl.disabled = true
    } else {
      // Disable radios, enable select
      radioInputs.forEach(r => r.disabled = true)
      if (selectEl) selectEl.disabled = false
    }
  }

  _isVisible(el) {
    if (!el) return false
    const style = window.getComputedStyle(el)
    return style.display !== 'none' && style.visibility !== 'hidden'
  }
}
