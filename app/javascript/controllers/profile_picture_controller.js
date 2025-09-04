// frozen_string_literal: true
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  pick() {
    this.inputTarget.click()
  }

  changed(event) {
    const file = this.inputTarget.files[0]
    if (!file) return this.clearPreview()
    const reader = new FileReader()
    reader.onload = e => {
      this.previewTarget.innerHTML = `<img src="${e.target.result}" alt="Podgląd" class="object-cover w-full h-full rounded-lg" />`
      this.previewTarget.classList.remove("hidden")
    }
    reader.readAsDataURL(file)
  }

  clearPreview() {
    this.previewTarget.innerHTML = ""
    this.previewTarget.classList.add("hidden")
  }
}
