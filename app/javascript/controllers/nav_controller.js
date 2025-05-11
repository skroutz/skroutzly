import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav"
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Navigation controller connected")
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("hidden")
  }
}
