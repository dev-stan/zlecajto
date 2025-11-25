import { Controller } from "@hotwired/stimulus"
import Headroom from "headroom.js"

export default class extends Controller {
  connect() {
    const headroom = new Headroom(this.element, {
      tolerance: 5,
      offset: 0,
      classes: {
        pinned: "slideDown",
        unpinned: "slideUp",
      }
    })
    headroom.init()
  }
}
