// frozen_string_literal: true

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close() {
    this.element.style.transition = "opacity 0.5s ease";
    this.element.style.opacity = "0";
    setTimeout(() => {
      this.element.remove();
    }, 500);
  }
}
