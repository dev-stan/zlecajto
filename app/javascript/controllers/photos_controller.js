import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photos"
export default class extends Controller {
  static targets = ["input", "count"]

  connect() {
    this.updateCount()
  }

  pick() {
    if (this.hasInputTarget) {
      this.inputTarget.click()
    }
  }

  changed() {
    this.updateCount()
  }

  updateCount() {
    if (!this.hasInputTarget || !this.hasCountTarget) return
    const files = this.inputTarget.files || []
    this.countTarget.textContent = files.length === 0 ? "" : `${files.length} selected`
  }
}
