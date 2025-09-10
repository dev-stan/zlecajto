import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.open = false
    this.update()
  }

  toggle() {
    this.open = !this.open
    this.update()
  }

  update() {
    if (this.open) {
      this.menuTarget.classList.remove("hidden")
    } else {
      this.menuTarget.classList.add("hidden")
    }
  }
}
