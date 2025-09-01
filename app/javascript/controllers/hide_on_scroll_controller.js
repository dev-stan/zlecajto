// frozen_string_literal: true

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this._onScroll = this.hideOnScroll.bind(this)
    window.addEventListener("scroll", this._onScroll)
  }

  disconnect() {
    window.removeEventListener("scroll", this._onScroll)
  }

  hideOnScroll() {
    if (window.scrollY > 10) {
      this.element.style.display = "none"
    }
  }
}
