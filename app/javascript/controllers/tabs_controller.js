import { Controller } from "@hotwired/stimulus"

// Basic accessible tabs: expects buttons with data-tab value and matching panels with data-tab value.
export default class extends Controller {
  static targets = ["tab", "panel"]

  show(event) {
    const tabValue = event.currentTarget.dataset.tab
    if (!tabValue) return
    this.activate(tabValue)
  }

  activate(tabValue) {
    this.tabTargets.forEach(btn => {
      const active = btn.dataset.tab === tabValue
      btn.classList.toggle('text-violet-700', active)
      btn.classList.toggle('border-violet-600', active)
      btn.classList.toggle('border-b-2', active)
      btn.classList.toggle('bg-white', active)
      btn.setAttribute('aria-selected', active ? 'true' : 'false')
    })
    this.panelTargets.forEach(panel => {
      panel.classList.toggle('hidden', panel.dataset.tab !== tabValue)
    })
  }
}
