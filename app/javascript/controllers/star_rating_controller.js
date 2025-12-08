import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star"]

  connect() {
    this.updateStars()
  }

  rate(event) {
    this.inputTarget.value = event.currentTarget.dataset.value
    this.updateStars()
  }

  updateStars() {
    const currentRating = parseInt(this.inputTarget.value) || 0

    this.starTargets.forEach((star, index) => {
      const icon = star.querySelector("i")
      const isSelected = (index + 1) <= currentRating
      const isPrimary = icon.classList.contains("text-primary")

      // transitions
      icon.classList.add("fas", "transition-all", "duration-200", "ease-in-out")

      if (isSelected !== isPrimary) {
        this.animateChange(icon, () => {
          icon.classList.toggle("text-primary", isSelected)
          icon.classList.toggle("text-gray-300", !isSelected)
        })
      }
    })
  }

  animateChange(icon, callback) {
    icon.style.opacity = "0"
    icon.style.transform = "scale(0.5)"
    
    setTimeout(() => {
      callback()
      icon.style.opacity = "1"
      icon.style.transform = "scale(1)"
    }, 200)
  }
}
