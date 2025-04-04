import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    // Auto hide after 5 seconds
    setTimeout(() => {
      this.hide();
    }, 5000);
  }

  hide() {
    this.element.classList.add("opacity-0");
    setTimeout(() => {
      this.element.remove();
    }, 500); // Delay removal after fade animation
  }

  close() {
    this.hide();
  }
}
