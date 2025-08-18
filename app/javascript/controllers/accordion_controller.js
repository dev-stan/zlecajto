import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "button", "icon"]

  connect() {
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
    const indexAttr = event.currentTarget.dataset.accordionIndex
    if (indexAttr === undefined) return
    const index = parseInt(indexAttr, 10)
    if (Number.isNaN(index) || !this.buttonTargets[index]) return
    const button = this.buttonTargets[index]
    const isExpanded = button.getAttribute('aria-expanded') === 'true'
    this.buttonTargets.forEach((_, i) => { if (i !== index) this.setExpanded(i, false) })
    this.setExpanded(index, !isExpanded)
  }

  setExpanded(index, expand, animate = true) {
    const panel = this.panelTargets[index]
    const button = this.buttonTargets[index]
    if (!panel || !button) return

    if (expand) {
      button.setAttribute('aria-expanded', 'true')
      const inner = panel.firstElementChild
      const targetHeight = inner ? inner.scrollHeight : panel.scrollHeight
      panel.style.maxHeight = targetHeight + 'px'
      if (this.hasIconTarget && this.iconTargets[index]) this.iconTargets[index].classList.add('rotate-180')
    } else {
      button.setAttribute('aria-expanded', 'false')
      panel.style.maxHeight = '0px'
      if (this.hasIconTarget && this.iconTargets[index]) this.iconTargets[index].classList.remove('rotate-180')
    }
  }
}
