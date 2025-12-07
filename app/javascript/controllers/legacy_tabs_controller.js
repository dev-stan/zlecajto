import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel", "indicator"]
  static values = {
    activeClass: String,
    inactiveClass: String
  }

   connect() {
    requestAnimationFrame(() => {
      const urlParams = new URLSearchParams(window.location.search)

      const initialTab = this.element.dataset.tabsInitialTab ||
                        new URLSearchParams(window.location.search).get("tab") ||
                        this.tabTargets[0]?.dataset.tab

      if (initialTab) this.activate(initialTab)
    })
  }

  show(event) {
    const tabValue = event.currentTarget.dataset.tab
    if (tabValue) this.activate(tabValue)
  }

  activate(tabValue) {
    const activeClassString = this.hasActiveClassValue ? this.activeClassValue : this.element.getAttribute("data-tabs-active-class")
    const inactiveClassString = this.hasInactiveClassValue ? this.inactiveClassValue : this.element.getAttribute("data-tabs-inactive-class")

    const useCustomClasses = this.hasActiveClassValue || this.hasInactiveClassValue || this.element.hasAttribute("data-tabs-active-class") || this.element.hasAttribute("data-tabs-inactive-class")

    const activeClasses = (activeClassString || "").split(" ").filter(Boolean)
    const inactiveClasses = (inactiveClassString || "").split(" ").filter(Boolean)

    this.tabTargets.forEach(btn => {
      const active = btn.dataset.tab === tabValue
      
      if (useCustomClasses) {
        if (active) {
          if (inactiveClasses.length) btn.classList.remove(...inactiveClasses)
          if (activeClasses.length) btn.classList.add(...activeClasses)
        } else {
          if (activeClasses.length) btn.classList.remove(...activeClasses)
          if (inactiveClasses.length) btn.classList.add(...inactiveClasses)
        }
      } else {
        // Fallback for legacy usage
        btn.classList.toggle("text-black", active)
        btn.classList.toggle("text-gray-500", !active)
      }
      
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
        "bg-primary",
        "rounded-full"
      )
      if (active) {
        indicator.classList.add(
          "absolute",
          "bottom-0",
          "left-0",
          "w-full",
          "h-[4px]",
          "bg-primary",
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
