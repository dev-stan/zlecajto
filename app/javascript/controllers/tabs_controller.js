import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel", "indicator"]

  connect() {
    const initialTab = this.element.querySelector('[aria-selected="true"]')?.dataset.tab;
    if (initialTab) {
      this.activate(initialTab);
    }
  }

  show(event) {
    const tabValue = event.currentTarget.dataset.tab;
    if (!tabValue) return;
    this.activate(tabValue);
  }

  activate(tabValue) {
    // 1. Update button text color and aria-selected attribute
    this.tabTargets.forEach(btn => {
      const active = btn.dataset.tab === tabValue;
      btn.classList.toggle('text-black', active);
      btn.classList.toggle('text-gray-500', !active);
      btn.setAttribute('aria-selected', active ? 'true' : 'false');
    });

    // 2. Update indicator visibility
    this.indicatorTargets.forEach(indicator => {
      const active = indicator.dataset.tab === tabValue;
      
      // Remove all indicator styling classes first
      indicator.classList.remove('absolute', 'bottom-0', 'left-0', 'w-full', 'h-[4px]', 'bg-blue-700', 'rounded-full');

      if (active) {
        // Add the classes back only to the active indicator
        indicator.classList.add('absolute', 'bottom-0', 'left-0', 'w-full', 'h-[4px]', 'bg-blue-700', 'rounded-full');
      }
    });

    // 3. Update panel visibility
    this.panelTargets.forEach(panel => {
      panel.classList.toggle('hidden', panel.dataset.tab !== tabValue);
    });
  }
}