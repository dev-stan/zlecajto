import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  async dismiss(event) {
    event?.preventDefault()
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    try {
      await fetch('/whats_new/dismiss', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': token || '',
          'Accept': 'text/vnd.turbo-stream.html, text/html, application/xhtml+xml, application/xml; q=0.9, */*; q=0.8'
        },
        credentials: 'same-origin'
      })
    } catch (e) {
      // no-op; cookie may remain unset but closing will still work
    }
  }
}
