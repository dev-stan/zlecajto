import { Controller } from "@hotwired/stimulus"

// data-controller="carousel"
// Expects slide targets (each absolute inset-0) and indicator targets.
// Adds simple fade transitions and keyboard navigation.
export default class extends Controller {
  static targets = ["slide", "indicator"]
  static values = { index: Number }

  connect() {
    if (isNaN(this.indexValue)) this.indexValue = 0
  // Force a reflow before showing to allow transition classes to animate
  requestAnimationFrame(() => this.showCurrent())
    this._keydown = (e) => {
      if (e.key === 'ArrowLeft') { this.prev() }
      if (e.key === 'ArrowRight') { this.next() }
    }
    document.addEventListener('keydown', this._keydown)
  }

  disconnect() {
    document.removeEventListener('keydown', this._keydown)
  }

  prev() {
    this.indexValue = (this.indexValue - 1 + this.slideTargets.length) % this.slideTargets.length
    this.showCurrent()
  }

  next() {
    this.indexValue = (this.indexValue + 1) % this.slideTargets.length
    this.showCurrent()
  }

  go(e) {
    const i = parseInt(e.params.index, 10)
    if (!isNaN(i)) {
      this.indexValue = i
      this.showCurrent()
    }
  }

  showCurrent() {
    this.slideTargets.forEach((el, i) => {
  const active = i === this.indexValue
  el.classList.toggle('opacity-100', active)
  el.classList.toggle('opacity-0', !active)
  el.classList.toggle('pointer-events-none', !active)
    })
    this.indicatorTargets.forEach((el, i) => {
      el.classList.toggle('bg-white', i === this.indexValue)
      el.classList.toggle('bg-white/50', i !== this.indexValue)
      el.classList.toggle('ring-2', i === this.indexValue)
      el.classList.toggle('ring-white', i === this.indexValue)
    })
  }
}
