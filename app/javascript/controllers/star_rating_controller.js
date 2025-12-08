import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star"]

  connect() {
    this.updateStars()
  }

  rate(event) {
    const rating = event.currentTarget.dataset.value
    this.inputTarget.value = rating
    this.updateStars()
  }

  updateStars() {
    const currentRating = parseInt(this.inputTarget.value) || 0
    this.starTargets.forEach((star, index) => {
      const starValue = index + 1
      const icon = star.querySelector("i")
      
      // Ensure transition classes are present
      if (!icon.classList.contains("transition-all")) {
        icon.classList.add("transition-all", "duration-200", "ease-in-out")
      }
      
      const isSelected = starValue <= currentRating
      const isSolid = icon.classList.contains("fa-solid")

      if (isSelected && !isSolid) {
        // Becoming selected
        this.animateChange(icon, () => {
          icon.classList.remove("fa-regular", "text-gray-300")
          icon.classList.add("fa-solid", "text-primary")
        })
      } else if (!isSelected && isSolid) {
        // Becoming unselected
        this.animateChange(icon, () => {
          icon.classList.remove("fa-solid", "text-primary")
          icon.classList.add("fa-regular", "text-gray-300")
        })
      } else if (isSelected && isSolid) {
        // Ensure correct color if already selected (e.g. fixing previous gray-400)
        if (icon.classList.contains("text-gray-400")) {
           icon.classList.remove("text-gray-400")
           icon.classList.add("text-primary")
        }
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
