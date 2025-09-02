import { Controller } from "@hotwired/stimulus"

const ERROR_CLASS = 'border-red-500'
// Only toggle the error color class. Removing the generic 'border' class caused
// radio labels to lose border width, so peer-checked:* color utilities had no visible effect.
const ERROR_CLASSES = [ERROR_CLASS]

export default class extends Controller {
  connect() {
    this.onInput = this.onInput.bind(this)
    this.element.addEventListener('input', this.onInput)
    this.element.addEventListener('change', this.onInput)
  }

  disconnect() {
    this.element.removeEventListener('input', this.onInput)
    this.element.removeEventListener('change', this.onInput)
  }

  validate(event) {
    this.clearErrors()
    const all = this.requiredFields()
    const invalid = this.collectInvalid(all)
    if (invalid.length === 0) return
    event.preventDefault()
    invalid.forEach(f => this.markInvalid(f))
    this.focusFirst(invalid)
  }

  onInput(e) {
    const el = e.target
    if (!el.classList.contains('required')) return
    if (el.type === 'radio' || el.type === 'checkbox') {
      // Re-evaluate entire group
      const group = this.group(el)
      if (group.some(member => !this.invalidField(member))) {
        group.forEach(member => this.unmarkInvalid(member))
      }
    } else if (!this.invalidField(el)) {
      this.unmarkInvalid(el)
    }
  }

  requiredFields() {
    return Array.from(this.element.querySelectorAll('.required'))
  }

  collectInvalid(fields) {
    const invalid = []
    const radioGroups = {}
    fields.forEach(f => {
      if (f.type === 'radio') {
        (radioGroups[f.name] ||= []).push(f)
      } else if (this.invalidField(f)) {
        invalid.push(f)
      }
    })
    Object.values(radioGroups).forEach(group => {
      if (!group.some(r => r.checked)) invalid.push(...group)
    })
    return invalid
  }

  invalidField(field) {
    if (field.type === 'radio' || field.type === 'checkbox') return !field.checked
    const v = field.value
    return v == null || v.toString().trim() === ''
  }

  group(radio) {
    return Array.from(this.element.querySelectorAll(`input[type=radio][name='${CSS.escape(radio.name)}'].required`))
  }

  markInvalid(field) {
    const label = this.labelFor(field)
    ;[field, label].filter(Boolean).forEach(el => this.applyErrorStyles(el))
  }

  unmarkInvalid(field) {
    const label = this.labelFor(field)
    ;[field, label].filter(Boolean).forEach(el => this.removeErrorStyles(el))
  }

  clearErrors() {
    // Select elements currently marked invalid by presence of ERROR_CLASS
    this.element.querySelectorAll('.' + CSS.escape(ERROR_CLASS)).forEach(el => this.removeErrorStyles(el))
  }

  applyErrorStyles(el) {
    if (!el) return
    // Ensure a visible border width exists
    if (!el.classList.contains('border')) {
      el.classList.add('border')
      el.dataset.addedBorder = 'true'
    }
    // Persist previous border color (first matching utility) to restore later
    const prev = Array.from(el.classList).find(c => c.startsWith('border-') && c !== 'border' && c !== ERROR_CLASS)
    if (prev && !el.dataset.prevBorderColor) el.dataset.prevBorderColor = prev
    // Remove previous color utility so new one is effective regardless of Tailwind generation order
    if (prev) el.classList.remove(prev)
    ERROR_CLASSES.forEach(c => el.classList.add(c))
  }

  removeErrorStyles(el) {
    if (!el) return
    ERROR_CLASSES.forEach(c => el.classList.remove(c))
    // Restore previous border color if we stored one
    if (el.dataset.prevBorderColor) {
      el.classList.add(el.dataset.prevBorderColor)
      delete el.dataset.prevBorderColor
    }
    // If we artificially added a border (e.g. plain text inputs), remove it again
    if (el.dataset.addedBorder) {
      el.classList.remove('border')
      delete el.dataset.addedBorder
    }
  }

  focusFirst(invalid) {
    const first = invalid[0]
    const target = this.labelFor(first) || first
    target?.focus?.({ preventScroll: true })
  }

  labelFor(field) {
    return field.id ? this.element.querySelector("label[for='" + CSS.escape(field.id) + "']") : null
  }
}
