import { Controller } from "@hotwired/stimulus"

// Ultra‑simple validation: every element with class 'required'
// must be either (checked for radios/checkboxes) or have a non‑blank value.
// We add a slim red border to the field and its label.
export default class extends Controller {
  validate(event) {
    const form = this.element
    // Clear previous marks
    form.querySelectorAll('.border-red-400').forEach(n => n.classList.remove('border-red-400'))

    const fields = Array.from(form.querySelectorAll('.required'))
    const invalid = fields.filter(f => this.invalidField(f))

    if (invalid.length === 0) return

    event.preventDefault()
    invalid.forEach(f => this.markInvalid(f))
    const first = invalid[0]
    const label = form.querySelector(`label[for='${CSS.escape(first.id)}']`)
    ;(label || first).focus?.({ preventScroll: true })
  }

  markInvalid(el) {
    const label = this.element.querySelector(`label[for='${CSS.escape(el.id)}']`)
    ;[el, label].filter(Boolean).forEach(n => n.classList.add('border', 'border-red-400'))
  }

  unmarkInvalid(el) { // kept for possible external use
    const label = this.element.querySelector(`label[for='${CSS.escape(el.id)}']`)
    ;[el, label].filter(Boolean).forEach(n => n.classList.remove('border-red-400'))
  }

  invalidField(f) {
    if (f.type === 'radio' || f.type === 'checkbox') return !f.checked
    const v = f.value
    return v == null || v.toString().trim() === ''
  }
}
