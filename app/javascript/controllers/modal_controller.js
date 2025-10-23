import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "content"]

  connect() {
    console.log("Modal controller connected")
    console.log("Has overlay target:", this.hasOverlayTarget)
    console.log("Has content target:", this.hasContentTarget)
    
    const content = this.hasContentTarget ? this.contentTarget : this.element.firstElementChild
    content?.classList.add("animate-fade-in")
  }

  close(event) {
    console.log("Close method called", event)
    event?.preventDefault()

    const overlay = this.hasOverlayTarget ? this.overlayTarget : null
    const content = this.hasContentTarget ? this.contentTarget : this.element.firstElementChild

    overlay?.classList.remove("animate-fade-in")
    content?.classList.remove("animate-fade-in")

    content?.classList.add("animate-fade-out")
    if (overlay) {
      overlay.classList.remove("bg-black/50")
      overlay.classList.add("bg-transparent")
    }

    // Clear shortly after transitions finish; keep in sync with CSS durations
    setTimeout(() => this.clear(), 300)
  }

  clear() {
    console.log("Clear method called")
    const modalFrame = document.querySelector('turbo-frame#modal')
    if (modalFrame && modalFrame.contains(this.element)) {
      modalFrame.innerHTML = ""
      return
    }
    // Fallback for standalone modals not inside the global turbo-frame
    this.element.remove()
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  // ✅ NEW: close modal when clicking outside content
  closeIfOutside(event) {
    if (!this.hasContentTarget || !this.contentTarget.contains(event.target)) {
      this.close(event)
    }
  }
}
