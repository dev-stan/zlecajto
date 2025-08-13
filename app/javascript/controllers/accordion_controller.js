import { Controller } from "@hotwired/stimulus"

// Animated accordion using max-height transitions. Single panel open at a time.
export default class extends Controller {
  static targets = ["panel", "button"]

  connect() {
    // Normalize initial state (panels with data-initial-open="true" are expanded)
    this.panelTargets.forEach((panel, i) => {
      const button = this.buttonTargets[i]
      const open = panel.dataset.initialOpen === 'true'
      if (open) {
  this.setExpanded(i, true, false) // no animation first paint
      } else {
        this.setExpanded(i, false, false)
      }
    })
  }

  toggle(event) {
    const index = parseInt(event.currentTarget.dataset.accordionIndex, 10)
    const button = this.buttonTargets[index]
    const isExpanded = button.getAttribute('aria-expanded') === 'true'

    // Close all others
    this.buttonTargets.forEach((_, i) => {
      if (i !== index) this.setExpanded(i, false)
    })

    // Toggle clicked one
    this.setExpanded(index, !isExpanded)
  }

  setExpanded(index, expand, animate = true) {
    const panel = this.panelTargets[index]
    const button = this.buttonTargets[index]
    if (!panel || !button) return

    if (expand) {
      button.setAttribute('aria-expanded', 'true')
      // Measure inner content height
      const inner = panel.firstElementChild
      const targetHeight = inner ? inner.scrollHeight : panel.scrollHeight
      if (!animate) {
        panel.style.maxHeight = targetHeight + 'px'
      } else {
        panel.style.maxHeight = targetHeight + 'px'
      }
    } else {
      button.setAttribute('aria-expanded', 'false')
      if (!animate) {
        panel.style.maxHeight = '0px'
      } else {
        panel.style.maxHeight = '0px'
      }
    }
  }
}
