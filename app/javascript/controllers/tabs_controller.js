import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel", "indicator"]
  static values = {
    activeClass: { type: String, default: "" },
    inactiveClass: { type: String, default: "" },
    defaultTab: String
  }

  connect() {
    const initialTab = this.defaultTabValue || 
                      new URLSearchParams(window.location.search).get("tab") || 
                      this.tabTargets[0]?.dataset.tab

    if (initialTab) {
      this.activate(initialTab)
    }
  }

  show(event) {
    this.activate(event.currentTarget.dataset.tab)
  }

  activate(tabName) {
    const activeTab = this.tabTargets.find(tab => tab.dataset.tab === tabName)
    
    if (activeTab) {
      this.updateIndicator(activeTab)
    }

    this.tabTargets.forEach(tab => {
      const isActive = tab.dataset.tab === tabName
      this.toggleClasses(tab, isActive)
      tab.setAttribute("aria-selected", isActive)
    })

    this.panelTargets.forEach(panel => {
      const shouldShow = panel.dataset.tab === tabName

      if (shouldShow) {
        panel.classList.remove("hidden")
        // Prepare initial state for animation
        panel.classList.add("transition-all", "duration-300", "ease-out", "opacity-0", "translate-y-2")
        
        // Trigger animation in the next frame
        requestAnimationFrame(() => {
          panel.classList.remove("opacity-0", "translate-y-2")
          panel.classList.add("opacity-100", "translate-y-0")
        })
      } else {
        panel.classList.add("hidden")
        panel.classList.remove("opacity-100", "translate-y-0")
      }
    })
  }

  updateIndicator(tab) {
    if (!this.hasIndicatorTarget) return

    this.indicatorTarget.style.width = `${tab.offsetWidth}px`
    this.indicatorTarget.style.transform = `translateX(${tab.offsetLeft}px)`
  }

  toggleClasses(element, isActive) {
    const activeClasses = this.activeClassValue.split(" ").filter(Boolean)
    const inactiveClasses = this.inactiveClassValue.split(" ").filter(Boolean)

    if (activeClasses.length === 0 && inactiveClasses.length === 0) return

    if (isActive) {
      element.classList.add(...activeClasses)
      element.classList.remove(...inactiveClasses)
    } else {
      element.classList.remove(...activeClasses)
      element.classList.add(...inactiveClasses)
    }
  }
}
