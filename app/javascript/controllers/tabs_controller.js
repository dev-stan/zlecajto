import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel", "indicator"]

   connect() {
    requestAnimationFrame(() => {
      const urlParams = new URLSearchParams(window.location.search)
      const tabFromUrl = urlParams.get("tab")

      const initialTab = this.element.dataset.tabsInitialTab ||
                        new URLSearchParams(window.location.search).get("tab") ||
                        this.tabTargets[0]?.dataset.tab

  if (initialTab) this.activate(initialTab)

      if (initialTab) this.activate(initialTab)
    })
  }

  show(event) {
    const tabValue = event.currentTarget.dataset.tab
    if (tabValue) this.activate(tabValue)
  }

  activate(tabValue) {
    // buttons
    this.tabTargets.forEach(btn => {
      const active = btn.dataset.tab === tabValue
      btn.classList.toggle("text-black", active)
      btn.classList.toggle("text-gray-500", !active)
      btn.setAttribute("aria-selected", active)
    })

    // indicators
    this.indicatorTargets.forEach(indicator => {
      const active = indicator.dataset.tab === tabValue
      indicator.classList.remove(
        "absolute",
        "bottom-0",
        "left-0",
        "w-full",
        "h-[4px]",
        "bg-blue-700",
        "rounded-full"
      )
      if (active) {
        indicator.classList.add(
          "absolute",
          "bottom-0",
          "left-0",
          "w-full",
          "h-[4px]",
          "bg-blue-700",
          "rounded-full"
        )
      }
    })

    // panels
    this.panelTargets.forEach(panel => {
      panel.classList.toggle("hidden", panel.dataset.tab !== tabValue)
    })
  }
}
