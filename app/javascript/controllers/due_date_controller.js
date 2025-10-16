import { Controller } from "@hotwired/stimulus"

// Toggles between picking a concrete date and selecting "Obojętnie"
export default class extends Controller {
	static targets = ["input", "any"]

	connect() {
		this.sync()
	}

	toggle() {
		// When the "Obojętnie" radio changes, disable/enable the date input
		this.sync()
	}

	uncheckAny() {
		// When user starts typing/choosing a date, uncheck the "Obojętnie" radio
		if (this.hasAnyTarget && this.inputTarget.value) {
			this.anyTarget.checked = false
		}
		this.sync()
	}

	sync() {
		const anySelected = this.hasAnyTarget && this.anyTarget.checked
		if (this.hasInputTarget) {
			// If any is selected, clear any invalid styles on the date
			if (anySelected) {
				this.inputTarget.classList.remove('border-red-500', 'focus:border-red-500')
				this.inputTarget.classList.add('border-gray-300')
				// Clear value to avoid sending conflicting values; backend can ignore when any is set
				this.inputTarget.value = ''
					const wrapper = this.element.closest('[data-field-wrapper]') || this.element
					const errorEl = wrapper.querySelector('[data-validation-error]')
					if (errorEl) errorEl.remove()
			}
		}
	}
}
