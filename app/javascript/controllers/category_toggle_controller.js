import { Controller } from "@hotwired/stimulus";

// Stimulus controller to enable only the visible category input (radio or select)
export default class extends Controller {
  static targets = ["categoryRadios", "categorySelect"];

  connect() {
    this.toggleCategoryInputs();
    window.addEventListener("resize", this.toggleCategoryInputs.bind(this));
  }

  disconnect() {
    window.removeEventListener("resize", this.toggleCategoryInputs.bind(this));
  }

  toggleCategoryInputs() {
    const radios = this.categoryRadiosTarget.querySelectorAll('input[type="radio"][name="task[category]"]');
    const select = this.categorySelectTarget;
    const radiosVisible = window.getComputedStyle(this.categoryRadiosTarget).display !== "none";
    if (radiosVisible) {
      select.disabled = true;
      radios.forEach(radio => radio.disabled = false);
    } else {
      select.disabled = false;
      radios.forEach(radio => radio.disabled = true);
    }
  }
}
