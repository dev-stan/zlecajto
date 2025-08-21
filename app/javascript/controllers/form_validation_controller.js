import { Controller } from "@hotwired/stimulus"

const ERROR_CLASS = 'border-red-400'
const ERROR_CLASSES = ['border', ERROR_CLASS]

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
    ;[field, label].filter(Boolean).forEach(el => ERROR_CLASSES.forEach(c => el.classList.add(c)))
  }

  unmarkInvalid(field) {
    const label = this.labelFor(field)
    ;[field, label].filter(Boolean).forEach(el => ERROR_CLASSES.forEach(c => el.classList.remove(c)))
  }

  clearErrors() {
    this.element.querySelectorAll('.' + ERROR_CLASS).forEach(el => this.unmarkInvalid(el))
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
