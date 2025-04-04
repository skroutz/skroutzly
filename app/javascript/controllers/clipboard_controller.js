import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];

  connect() {
    this.buttonTargets.forEach((button) => {
      button.addEventListener("click", this.handleClick);
    });
  }

  disconnect() {
    this.buttonTargets.forEach((button) => {
      button.removeEventListener("click", this.handleClick);
    });
  }

  handleClick(event) {
    const button = event.currentTarget;
    navigator.clipboard.writeText(button.dataset.clipboardText).then(() => {
      const originalInnerHTML = button.innerHTML;

      // Show success indicator
      button.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
      `;

      // Revert back after 2 seconds
      setTimeout(() => {
        button.innerHTML = originalInnerHTML;
      }, 2000);
    });
  }
}
