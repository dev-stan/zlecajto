import { Controller } from "@hotwired/stimulus"
import Headroom from "headroom.js"

export default class extends Controller {
  connect() {
    console.log("Headroom controller connected")
    // Wait for DOM and CSS to settle
    requestAnimationFrame(() => {
      const scroller = document.getElementById("messages") || window

      const headroom = new Headroom(this.element, {
        tolerance: 5,
        offset: 0,
        classes: {
          pinned: "slideDown",
          unpinned: "slideUp",
        },
        scroller: scroller
      })
      headroom.init()
    })
  }
}
