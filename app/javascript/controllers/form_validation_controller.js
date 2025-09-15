import { Controller } from "@hotwired/stimulus"

const ERROR_CLASS = 'border-red-500'
// Only toggle the error color class. Removing the generic 'border' class caused
// radio labels to lose border width, so peer-checked:* color utilities had no visible effect.
const ERROR_CLASSES = [ERROR_CLASS]

export default class extends Controller {
  connect() {
    console.log("FormValidationController connected")
    this.onInput = this.onInput.bind(this)
    this.element.addEventListener('input', this.onInput)
    this.element.addEventListener('change', this.onInput)
  // Ensure radios whose labels carry the required marker or have required attribute are tracked
  this.syncRequiredMarkers()
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
      const group = this.allGroupMembers(el)
      if (group.some(member => member.checked)) {
        group.forEach(member => this.unmarkInvalid(member))
      }
    } else if (!this.invalidField(el)) {
      this.unmarkInvalid(el)
    }
  }

  requiredFields() {
    // Base: elements explicitly marked with required class
    const fromClass = Array.from(this.element.querySelectorAll('.required'))
    // Include radios / checkboxes whose label has required class
    const radios = Array.from(this.element.querySelectorAll('input[type=radio], input[type=checkbox]'))
      .filter(input => !input.classList.contains('required'))
      .filter(input => input.hasAttribute('required') || this.labelFor(input)?.classList.contains('required'))
    return Array.from(new Set([...fromClass, ...radios]))
  }

  collectInvalid(fields) {
    const invalid = []
    const radioNames = new Set()
    fields.forEach(f => {
      if (f.type === 'radio') {
        radioNames.add(f.name)
      } else if (this.invalidField(f)) {
        invalid.push(f)
      }
    })
    // Evaluate each radio group by name, considering all radios in the form (not just those with required class)
    radioNames.forEach(name => {
  const group = this.radiosByName(name)
      if (!group.some(r => r.checked)) invalid.push(...group)
    })
    return invalid
  }

  invalidField(field) {
    if (field.type === 'radio' || field.type === 'checkbox') return !field.checked
    const v = field.value
    return v == null || v.toString().trim() === ''
  }

  // Return all radios sharing this one's name (full group regardless of required class presence)
  allGroupMembers(radio) {
    return this.radiosByName(radio.name)
  }

  radiosByName(name) {
    // getElementsByName avoids CSS selector escaping edge cases (e.g. brackets in param names)
    return Array.from(document.getElementsByName(name)).filter(el => el instanceof HTMLInputElement && el.type === 'radio' && el.form === this.element)
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

  // Propagate required marker from labels / attributes to the underlying inputs so onInput logic fires.
  syncRequiredMarkers() {
    const candidates = Array.from(this.element.querySelectorAll('label.required[for]'))
    candidates.forEach(label => {
      const id = label.getAttribute('for')
      if (!id) return
      const input = this.element.querySelector('#' + CSS.escape(id))
      if (input && !input.classList.contains('required')) {
        input.classList.add('required')
        input.dataset.inheritedRequired = 'true'
      }
    })
    // Also mark inputs with native required attribute
    this.element.querySelectorAll('input[required]').forEach(input => {
      if (!input.classList.contains('required')) {
        input.classList.add('required')
        input.dataset.inheritedRequired = 'true'
      }
    })
  }
}
