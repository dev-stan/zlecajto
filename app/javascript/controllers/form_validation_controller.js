// app/javascript/controllers/form_validation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    step: Number
  }

  // All validation rules defined here
  get validationRules() {
    return {
      0: {
        'submission[note]': {
          required: true,
          minLength: 25,
          maxLength: 500,
          fieldName: 'Wiadomość',
          // Custom validator to prevent sharing contact details
          validator: (value) => {
            // Detect common email patterns within text
            const emailPattern = /[^\s@]+@[^\s@]+\.[^\s@]+/i
            if (emailPattern.test(value)) {
              return 'Nie podawaj tu swojego adresu email! Gdy zostaniesz wybrany do wykonania zlecenia, zleceniodawca zobaczy email, który widoczny jest na twoim profilu!'
            }

            // Detect Polish phone numbers within text, e.g. 123456789, 123 456 789, 123-456-789, +48 123 456 789
            const phonePattern = /(?:\+48\s*)?(?:\d[\s-]?){9}(?!\d)/
            if (phonePattern.test(value)) {
              return 'Nie podawaj tu swojego numeru telefonu! Gdy zostaniesz wybrany do wykonania zlecenia, zleceniodawca zobaczy numer, który widoczny jest na twoim profilu!'
            }

            return null
          },
          errors: {
            required: 'Wiadomość do zleceniodawcy jest wymagana',
            minLength: 'Wiadomość musi mieć co najmniej 25 znaków',
            maxLength: 'Wiadomość nie może przekraczać 500 znaków'
          }
        }
      },
      1: {
        'task[title]': {
          required: true,
          minLength: 10,
          maxLength: 50,
          fieldName: 'Tytuł',
          validator: (value) => {
            // Detect common email patterns within text
            const emailPattern = /[^\s@]+@[^\s@]+\.[^\s@]+/i
            if (emailPattern.test(value)) {
              return 'Nie podawaj tu swojego adresu email! Będzie on widoczny po wybraniu wykonawcy.'
            }

            // Detect Polish phone numbers within text, e.g. 123456789, 123 456 789, 123-456-789, +48 123 456 789
            const phonePattern = /(?:\+48\s*)?(?:\d[\s-]?){9}(?!\d)/
            if (phonePattern.test(value)) {
              return 'Nie podawaj tu swojego numeru telefonu! Będzie on widoczny po wybraniu wykonawcy.'
            }

            return null
          },
          errors: {
            required: 'Tytuł jest wymagany',
            minLength: 'Tytuł musi mieć co najmniej 10 znaków',
            maxLength: 'Tytuł nie może przekraczać 100 znaków'
          }
        },
        'task[category]': {
          required: true,
          fieldName: 'Kategoria',
          errors: {
            required: 'Kategoria jest wymagana'
          }
        },
        'task[due_date]': {
          required: true,
          futureDate: true,
          fieldName: 'Data',
          errors: {
            required: 'Data jest wymagana',
            futureDate: 'Data musi być dziś lub w przyszłości'
          }
        },
        'task[timeslot]': {
          required: true,
          fieldName: 'Godzina',
          errors: {
            required: 'Godzina jest wymagana'
          }
        }
      },
      2: {
        'task[description]': {
          required: true,
          minLength: 20,
          maxLength: 1000,
          fieldName: 'Opis',
          validator: (value) => {
            // Detect common email patterns within text
            const emailPattern = /[^\s@]+@[^\s@]+\.[^\s@]+/i
            if (emailPattern.test(value)) {
              return 'Nie podawaj tu swojego adresu email! Będzie on widoczny po wybraniu wykonawcy.'
            }

            // Detect Polish phone numbers within text, e.g. 123456789, 123 456 789, 123-456-789, +48 123 456 789
            const phonePattern = /(?:\+48\s*)?(?:\d[\s-]?){9}(?!\d)/
            if (phonePattern.test(value)) {
              return 'Nie podawaj tu swojego numeru telefonu! Będzie on widoczny po wybraniu wykonawcy.'
            }

            return null
          },
          errors: {
            required: 'Opis zadania jest wymagany',
            minLength: 'Opis musi mieć co najmniej 20 znaków',
            maxLength: 'Opis nie może przekraczać 1000 znaków'
          }
        }
      },
      3: {
        'task[location]': {
          required: true,
          fieldName: 'Lokalizacja',
          errors: {
            required: 'Miejsce wykonania zadania jest wymagane'
          }
        }
      },
      4: {
        'task[salary]': {
          required: true,
          pattern: /^\d+$/,
          minValue: 0,
          fieldName: 'Stawka',
          errors: {
            required: 'Stawka jest wymagana',
            pattern: 'Stawka musi być liczbą',
            minValue: 'Stawka musi być dodatnia ( lub 0 za darmo )'
          }
        },
        'task[payment_method]': {
          required: true,
          fieldName: 'Metoda płatności',
          errors: {
            required: 'Metoda płatności jest wymagana'
          }
        }
      },
      5: {
        'task[phone]': {
          required: true,
          pattern: /^(\+48)?[\s-]?\d{3}[\s-]?\d{3}[\s-]?\d{3}$/,
          fieldName: 'Telefon',
          errors: {
            required: 'Numer telefonu jest wymagany',
            pattern: 'Wprowadź prawidłowy numer telefonu (np. 123 456 789)'
          }
        },
        'task[address]': {
          required: true,
          minLength: 5,
          fieldName: 'Adres',
          errors: {
            required: 'Adres jest wymagany',
            minLength: 'Adres musi mieć co najmniej 5 znaków'
          }
        }
      },
      // Registration form validation (step 100)
      100: {
        'user[first_name]': {
          required: true,
          fieldName: 'Imię',
          errors: {
            required: 'Imię jest wymagane',
          }
        },
        'user[last_name]': {
          required: true,
          fieldName: 'Nazwisko',
          errors: {
            required: 'Nazwisko jest wymagane',
          }
        },
        'user[email]': {
          required: true,
          email: true,
          fieldName: 'Adres email',
          errors: {
            required: 'Adres email jest wymagany',
            email: 'Wprowadź prawidłowy adres email'
          }
        },
        'user[phone_number]': {
          required: true,
          pattern: /^(\+48)?[\s-]?\d{3}[\s-]?\d{3}[\s-]?\d{3}$/,
          fieldName: 'Numer telefonu',
          errors: {
            required: 'Numer telefonu jest wymagany',
            pattern: 'Wprowadź prawidłowy numer telefonu (np. 123 456 789)'
          }
        },
        'user[password]': {
          required: true,
          minLength: 8,
          maxLength: 128,
          fieldName: 'Hasło',
          errors: {
            required: 'Hasło jest wymagane',
            minLength: 'Hasło musi mieć co najmniej 8 znaków',
            maxLength: 'Hasło nie może przekraczać 128 znaków'
          }
        }
      },
      // Edit task modal (step 200)
      200: {
        'task[title]': {
          required: true,
          minLength: 5,
          maxLength: 100,
          fieldName: 'Tytuł',
          errors: {
            required: 'Tytuł jest wymagany',
            minLength: 'Tytuł musi mieć co najmniej 5 znaków',
            maxLength: 'Tytuł nie może przekraczać 100 znaków'
          }
        },
        'task[salary]': {
          required: true,
          pattern: /^\d+$/,
          minValue: 0,
          fieldName: 'Wynagrodzenie',
          errors: {
            pattern: 'Wynagrodzenie musi być liczbą',
            minValue: 'Kwota nie może być ujemna'
          }
        },
        'task[description]': {
          required: true,
          minLength: 20,
          maxLength: 1000,
          fieldName: 'Opis',
          errors: {
            required: 'Opis jest wymagany',
            minLength: 'Opis musi mieć co najmniej 20 znaków',
            maxLength: 'Opis nie może przekraczać 1000 znaków'
          }
        },
        'task[category]': {
          required: true,
          fieldName: 'Kategoria',
          errors: {
            required: 'Kategoria jest wymagana'
          }
        },
        'task[location]': {
          required: true,
          fieldName: 'Lokalizacja',
          errors: {
            required: 'Lokalizacja jest wymagana'
          }
        },
        'task[timeslot]': {
          required: true,
          fieldName: 'Termin',
          errors: {
            required: 'Termin jest wymagany'
          }
        },
        'task[payment_method]': {
          required: true,
          fieldName: 'Płatność',
          errors: {
            required: 'Metoda płatności jest wymagana'
          }
        }
      },
      // Task messages (questions/replies) modal (step 300)
      300: {
        'task_message[body]': {
          required: true,
          maxLength: 2500,
          fieldName: 'Wiadomość',
          validator: (value) => {
            // Detect common email patterns within text
            const emailPattern = /[^\s@]+@[^\s@]+\.[^\s@]+/i
            if (emailPattern.test(value)) {
              return 'Nie podawaj tu swojego adresu email! Gdy zostaniesz wybrany/a do wykonania zlecenia, zleceniodawca zobaczy email, który możesz zmienić w twoim profilu!'
            }

            // Detect Polish phone numbers within text, e.g. 123456789, 123 456 789, 123-456-789, +48 123 456 789
            const phonePattern = /(?:\+48\s*)?(?:\d[\s-]?){9}(?!\d)/
            if (phonePattern.test(value)) {
              return 'Nie podawaj tu swojego numeru telefonu! Gdy zostaniesz wybrany/a do wykonania zlecenia, zleceniodawca zobaczy numer, który możesz zmienić w twoim profilu!'
            }

            return null
          },
          errors: {
            required: 'Wiadomość jest wymagana',
            maxLength: 'Wiadomość nie może przekraczać 2500 znaków'
          }
        }
      }
      ,
      400: {
        'answer[message]': {
          required: true,
          fieldName: 'Wiadomość',
          // Custom validator to prevent sharing contact details
          validator: (value) => {
            // Detect common email patterns within text
            const emailPattern = /[^\s@]+@[^\s@]+\.[^\s@]+/i
            if (emailPattern.test(value)) {
              return 'Nie podawaj tu swojego adresu email! Gdy zostaniesz wybrany/a do wykonania zlecenia, zleceniodawca zobaczy email, który możesz zmienić w twoim profilu!'
            }

            // Detect Polish phone numbers within text, e.g. 123456789, 123 456 789, 123-456-789, +48 123 456 789
            const phonePattern = /(?:\+48\s*)?(?:\d[\s-]?){9}(?!\d)/
            if (phonePattern.test(value)) {
              return 'Nie podawaj tu swojego numeru telefonu! Gdy zostaniesz wybrany/a do wykonania zlecenia, zleceniodawca zobaczy numer, który możesz zmienić w twoim profilu!'
            }

            return null
          },
          errors: {
            required: 'Wiadomość do zleceniodawcy jest wymagana',
          }
        }
      }
    
    }

  }

  connect() {
    console.log('FormValidationController connected')
    this.updateStepValue()
    this.attachRealTimeListeners()
  }

  attachRealTimeListeners() {
    // Listen for input changes on text fields, textareas, selects, date inputs
    this.element.addEventListener('input', (e) => {
      if (e.target.matches('input[type="text"], input[type="email"], input[type="date"], input[type="number"], textarea, select')) {
        this.validateFieldRealTime(e.target)
      }
    })

    // Listen for change events on radio buttons
    this.element.addEventListener('change', (e) => {
      if (e.target.matches('input[type="radio"]')) {
        this.validateFieldRealTime(e.target)
      }
    })

    // Listen for blur to validate on focus loss
    this.element.addEventListener('blur', (e) => {
      if (e.target.matches('input, select, textarea')) {
        this.validateFieldRealTime(e.target)
      }
    }, true)
  }

  validateFieldRealTime(field) {
    this.updateStepValue()
    const currentStepRules = this.validationRules[this.stepValue] || {}
    const rules = currentStepRules[field.name]
    
    if (rules) {
      this.validateFieldWithRules(field, rules)
    }
  }

  updateStepValue() {
    const stepInput = this.element.querySelector('input[name="step"], input[name="form[step]"]')
    if (stepInput) {
      const parsed = parseInt(stepInput.value)
      this.stepValue = Number.isNaN(parsed) ? 0 : parsed
    } else {
      this.stepValue = 0
    }
  }


  validate(event) {
    this.updateStepValue()
    this.clearAllErrors()
    this.clearBanner()

    const isValid = this.validateAllFields()

    if (!isValid) {
      event.preventDefault()
      event.stopImmediatePropagation()
    }

    return isValid
  }

  validateAllFields() {
    const currentStepRules = this.validationRules[this.stepValue] || {}
    const fields = this.getAllValidatableFields()
    let isValid = true
    let firstInvalidField = null

    fields.forEach(field => {
      const rules = currentStepRules[field.name]
      if (!rules) return

      if (!this.validateFieldWithRules(field, rules)) {
        isValid = false
        if (!firstInvalidField) {
          firstInvalidField = field
        }
      }
    })

    if (firstInvalidField) {
      this.scrollToField(firstInvalidField)
    }

    return isValid
  }

  validateFieldWithRules(field, rules) {
    if (field.type === 'hidden' || field.disabled || !this.isVisible(field)) {
      return true
    }

    const value = this.getFieldValue(field)
    const { validator, ...baseRules } = rules || {}
    
    // Check base rules WITHOUT custom validator
    const error = this.checkValidationRules(field, value, baseRules)
    
    // Check custom validator separately
    let contactError = null
    if (typeof validator === 'function') {
      contactError = validator(value, field)
    }

    // If contact error exists, block submission regardless of base errors
    if (contactError) {
      this.showBanner(contactError, { variant: 'warning' })
      // Show the contact error as inline error too if no base error
      if (!error) {
        this.showError(field, contactError)
      } else {
        this.showError(field, error)
      }
      return false
    }

    // Handle base errors
    if (error) {
      this.showError(field, error)
      this.clearBanner()
      return false
    }

    // All validations passed
    this.clearError(field)
    this.clearBanner()
    return true
  }

  showBanner(message, { variant = 'warning' } = {}) {
    window.dispatchEvent(new CustomEvent('banner:show', { detail: { message, variant } }))
  }

  clearBanner() {
    window.dispatchEvent(new CustomEvent('banner:clear'))
  }

  checkValidationRules(field, value, rules) {
    // Allow skipping due date if "Obojętnie" is selected
    if (field.name === 'task[due_date]') {
      const anySelected = this.element.querySelector('input[name="task[due_date_any]"]:checked')
      if (anySelected) {
        return null
      }
    }

    // Required validation
    if (rules.required && !value) {
      return rules.errors?.required || `${rules.fieldName || 'To pole'} jest wymagane`
    }

    // Skip other validations if field is empty and not required
    if (!value) return null

    // Min length
    if (rules.minLength && value.length < rules.minLength) {
      return rules.errors?.minLength || 
             `${rules.fieldName} musi mieć co najmniej ${rules.minLength} znaków`
    }

    // Max length
    if (rules.maxLength && value.length > rules.maxLength) {
      return rules.errors?.maxLength || 
             `${rules.fieldName} nie może przekraczać ${rules.maxLength} znaków`
    }

    // Min value (for numbers)
    if (rules.minValue !== undefined && parseFloat(value) < rules.minValue) {
      return rules.errors?.minValue || 
             `${rules.fieldName} musi być większy niż ${rules.minValue}`
    }

    // Max value (for numbers)
    if (rules.maxValue !== undefined && parseFloat(value) > rules.maxValue) {
      return rules.errors?.maxValue || 
             `${rules.fieldName} nie może przekraczać ${rules.maxValue}`
    }

    // Email validation
    if (rules.email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(value)) {
        return rules.errors?.email || 'Wprowadź prawidłowy adres email'
      }
    }

    // Pattern validation
    if (rules.pattern) {
      const pattern = rules.pattern instanceof RegExp ? rules.pattern : new RegExp(rules.pattern)
      if (!pattern.test(value)) {
        return rules.errors?.pattern || `${rules.fieldName} ma nieprawidłowy format`
      }
    }

    // Future date validation
    if (rules.futureDate && field.type === 'date') {
      const selectedDate = new Date(value)
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      
      if (selectedDate < today) {
        return rules.errors?.futureDate || 'Data musi być w przyszłości'
      }
    }

    return null
  }

  getFieldValue(field) {
    if (field.type === 'checkbox') {
      return field.checked ? field.value : ''
    }
    if (field.type === 'radio') {
      const checked = this.element.querySelector(`input[name="${field.name}"]:checked`)
      return checked ? checked.value : ''
    }
    return (field.value || '').trim()
  }

  isVisible(field) {
    return field.offsetParent !== null
  }

  getAllValidatableFields() {
    return Array.from(
      this.element.querySelectorAll('input:not([name="step"]):not([name="authenticity_token"]), select, textarea')
    ).filter(field => {
      // For radio buttons, only include one per group
      if (field.type === 'radio') {
        const name = field.name
        const firstRadio = this.element.querySelector(`input[name="${name}"]`)
        return field === firstRadio
      }
      return true
    })
  }

  showError(field, message) {
    const wrapper = this.getFieldWrapper(field)
    
    this.addErrorStyling(field)

    let errorElement = wrapper.querySelector('[data-validation-error]')
    
    if (!errorElement) {
      errorElement = document.createElement('p')
      errorElement.setAttribute('data-validation-error', '')
      errorElement.className = 'text-red-600 text-sm mt-1 opacity-0 transition-opacity duration-300'
      errorElement.setAttribute('role', 'alert')
      
      const insertPoint = this.getErrorInsertionPoint(field, wrapper)
      insertPoint.appendChild(errorElement)
      
      // Trigger fade in after element is in DOM
      setTimeout(() => {
        errorElement.classList.remove('opacity-0')
        errorElement.classList.add('opacity-100')
      }, 10)
    }

    errorElement.textContent = message
  }

  clearError(field) {
    const wrapper = this.getFieldWrapper(field)
    
    this.removeErrorStyling(field)

    const errorElement = wrapper.querySelector('[data-validation-error]')
    if (errorElement) {
      // Fade out before removing
      errorElement.classList.remove('opacity-100')
      errorElement.classList.add('opacity-0')
      
      // Remove from DOM after transition completes
      setTimeout(() => {
        errorElement.remove()
      }, 300)
    }
  }

  clearAllErrors() {
    this.element.querySelectorAll('[data-validation-error]').forEach(el => el.remove())
    
    this.element.querySelectorAll('.border-red-500').forEach(field => {
      this.removeErrorStyling(field)
    })

    // Clear radio button individual errors
    this.element.querySelectorAll('label.ring-red-500').forEach(label => {
      label.classList.remove( 'ring-red-500', 'border-red-500')
      label.classList.add('border-blue-500')
    })
  }

  addErrorStyling(field) {
    if (field.type === 'radio') {
      // Add red border to ALL radio button labels in the group
      const radioGroup = this.element.querySelectorAll(`input[name="${field.name}"]`)
      radioGroup.forEach(radio => {
        const label = this.element.querySelector(`label[for="${radio.id}"]`)
        if (label) {
          label.classList.add('transition-all', 'duration-300')
          // Use setTimeout to trigger transition
          setTimeout(() => {
            label.classList.add( 'ring-red-500', 'border-red-500')
            label.classList.remove('border-blue-500')
          }, 10)
        }
      })
    } else {
      // Style the input field with transition
      field.classList.add('transition-all', 'duration-300')
      setTimeout(() => {
        field.classList.add('border-red-500', 'focus:border-red-500')
        field.classList.remove('border-blue-500', 'border-gray-300')
      }, 10)
    }
  }

  removeErrorStyling(field) {
    if (field.type === 'radio') {
      // Remove red border from ALL radio button labels in the group
      const radioGroup = this.element.querySelectorAll(`input[name="${field.name}"]`)
      radioGroup.forEach(radio => {
        const label = this.element.querySelector(`label[for="${radio.id}"]`)
        if (label) {
          label.classList.remove( 'ring-red-500', 'border-red-500')
          label.classList.add('border-blue-500')
        }
      })
    } else {
      field.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-500')
      field.classList.add('border-gray-300')
    }
  }

  getFieldWrapper(field) {
    const explicitWrapper = field.closest('[data-field-wrapper]')
    if (explicitWrapper) return explicitWrapper

    if (field.type === 'radio') {
      // For radio buttons, the wrapper is the container with data-field-wrapper
      // or the parent of all radio buttons
      return field.closest('[data-field-wrapper]') || field.closest('div')
    }

    return field.closest('div') || field.parentElement
  }

  getErrorInsertionPoint(field, wrapper) {
    if (field.type === 'radio') {
      // Insert error after the radio group (ul/grid)
      const radioContainer = wrapper.querySelector('ul, .grid')
      return radioContainer?.parentElement || wrapper
    }
    
    return wrapper
  }

  scrollToField(field) {
    const wrapper = this.getFieldWrapper(field)
    const yOffset = -100
    const y = wrapper.getBoundingClientRect().top + window.pageYOffset + yOffset

    window.scrollTo({ top: y, behavior: 'smooth' })
    
    setTimeout(() => {
      if (field.type !== 'radio') {
        field.focus()
      }
    }, 300)
  }
}