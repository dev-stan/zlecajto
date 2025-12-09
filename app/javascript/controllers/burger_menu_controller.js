import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "icon"]

  connect() {
    // Ensure initial state
    this.menuTarget.classList.add("hidden", "opacity-0", "-translate-y-2")
  }

  toggle() {
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    // 1. Unhide
    this.menuTarget.classList.remove("hidden")
    
    // 2. Force reflow to enable transition
    this.menuTarget.offsetHeight
    
    // 3. Animate in
    this.menuTarget.classList.remove("opacity-0", "-translate-y-2")
    this.menuTarget.classList.add("opacity-100", "translate-y-0")

    // 4. Rotate/Change icon
    this.iconTarget.classList.remove("fa-bars")
    this.iconTarget.classList.add("fa-times", "rotate-90")
  }

  close() {
    // 1. Animate out
    this.menuTarget.classList.remove("opacity-100", "translate-y-0")
    this.menuTarget.classList.add("opacity-0", "-translate-y-2")

    // 2. Rotate/Change icon back
    this.iconTarget.classList.remove("fa-times", "rotate-90")
    this.iconTarget.classList.add("fa-bars")

    // 3. Hide after transition
    setTimeout(() => {
      this.menuTarget.classList.add("hidden")
    }, 300) // Matches duration-300
  }
}
