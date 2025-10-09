// app/javascript/controllers/banner_controller.js
import { Controller } from "@hotwired/stimulus"

// A lightweight banner/alert presenter. Listen for events and render a dismissible banner.
// Usage:
// <div data-controller="banner" data-action="banner:show@window->banner#showEvent banner:clear@window->banner#clear"></div>
// window.dispatchEvent(new CustomEvent('banner:show', { detail: { message: '...', variant: 'warning', autoDismiss: false } }))
export default class extends Controller {
  static values = {
    autoDismiss: { type: Boolean, default: false }
  }

  showEvent(event) {
    const { message, variant = 'warning', autoDismiss } = event.detail || {}
    if (!message) return
    this.show(message, { variant, autoDismiss })
  }

  show(message, { variant = 'warning', autoDismiss = this.autoDismissValue } = {}) {
    // Remove any existing banner instantly before showing a new one
    this.clearImmediate()

    const { bg, border, text } = this.variantClasses(variant)

    const wrapper = document.createElement('div')
    wrapper.className = `relative mb-4 border ${border} rounded-lg p-3 sm:p-4 ${bg} ${text} shadow-sm overflow-hidden`
    wrapper.setAttribute('role', 'alert')

    wrapper.innerHTML = `
      <div class="text-base font-medium">${this.escapeHtml(message)}</div>
    `

    // Prepare fade-in
    wrapper.style.opacity = '0'
    wrapper.style.transform = 'translateY(-4px)'
    wrapper.style.transition = 'opacity 150ms ease, transform 150ms ease'

    this.element.appendChild(wrapper)

    // Trigger fade-in
    requestAnimationFrame(() => {
      wrapper.style.opacity = '1'
      wrapper.style.transform = 'translateY(0)'
    })

    if (autoDismiss) this.autoDismiss()
  }

  // Handles banner:clear event with fade-out
  clear() { this.fadeOutAndClear() }

  // Internal immediate clear (no animation)
  clearImmediate() {
    if (this._timeout) {
      clearTimeout(this._timeout)
      this._timeout = null
    }
    this.element.innerHTML = ''
  }

  dismiss() { this.fadeOutAndClear() }

  autoDismiss() { this._timeout = setTimeout(() => this.fadeOutAndClear(), 5000) }

  fadeOutAndClear() {
    const banner = this.element.firstElementChild
    if (!banner) return
    banner.style.opacity = '0'
    banner.style.transform = 'translateY(-4px)'
    banner.style.transition = 'opacity 150ms ease, transform 150ms ease'
    setTimeout(() => this.clearImmediate(), 160)
  }

  variantClasses(variant) {
    switch (variant) {
      case 'success':
        return { bg: 'bg-green-50', border: 'border-green-300', text: 'text-green-800' }
      case 'error':
        return { bg: 'bg-red-50', border: 'border-red-300', text: 'text-red-800' }
      case 'info':
        return { bg: 'bg-blue-50', border: 'border-blue-300', text: 'text-blue-800' }
      case 'warning':
      default:
        return { bg: 'bg-yellow-50', border: 'border-yellow-300', text: 'text-yellow-800' }
    }
  }

  escapeHtml(str) {
    return String(str)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;')
  }
}
