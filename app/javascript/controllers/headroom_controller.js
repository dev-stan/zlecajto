import { Controller } from "@hotwired/stimulus"
import Headroom from "headroom.js"

export default class extends Controller {
  connect() {
    requestAnimationFrame(() => {
      const scroller = document.getElementById("messages") || window

      this.headroom = new Headroom(this.element, {
        tolerance: 5,
        offset: 0,
        classes: {
          pinned: "slideDown",
          unpinned: "slideUp",
        },
        scroller: scroller
      })

      this.headroom.init()
    })
  }

  disconnect() {
    if (this.headroom) {
      this.headroom.destroy()
      this.headroom = null
    }
  }
}
