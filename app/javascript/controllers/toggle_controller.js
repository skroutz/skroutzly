import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    elementId: String,
  };

  toggle(event) {
    event.preventDefault();
    document.getElementById(this.elementIdValue).classList.toggle("hidden");
  }

  show(event) {
    event.preventDefault();
    document.getElementById(this.elementIdValue).classList.remove("hidden");
  }

  hide(event) {
    event.preventDefault();
    document.getElementById(this.elementIdValue).classList.add("hidden");
  }
}
