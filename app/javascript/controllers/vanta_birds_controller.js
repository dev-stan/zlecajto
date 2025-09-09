import { Controller } from "@hotwired/stimulus"
import { mountVantaBirds, destroyVantaBirds } from "vanta_birds"

// data-controller="vanta-birds"
export default class extends Controller {
  connect() {
    mountVantaBirds(this.element)
  }
  disconnect() {
    destroyVantaBirds(this.element)
  }
}
