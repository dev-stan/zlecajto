import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoDismiss: Boolean }

  connect() {
    if (this.autoDismissValue) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, 50000) // 5 seconds till alert disappears
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  dismiss() {
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(100%)"
    
    setTimeout(() => {
      this.element.remove()
    }, 500) // Wait for animation to complete
  }
}
