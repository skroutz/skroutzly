import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button"];
  static values = {
    showToast: { type: Boolean, default: true },
    toastDuration: { type: Number, default: 3000 }
  };

  connect() {
    // We're not using the event listener approach since it creates a binding issue with 'this'
    // and the component scope
  }

  copy(event) {
    event.preventDefault();
    const button = event.currentTarget;
    const textToCopy = button.dataset.clipboardText;
    const displayText = textToCopy.length > 30 ? textToCopy.substring(0, 30) + '...' : textToCopy;
    
    navigator.clipboard.writeText(textToCopy).then(() => {
      // Store original icon
      const originalInnerHTML = button.innerHTML;
      
      // Change to success icon
      button.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
        </svg>
      `;
      
      // If toast notifications are enabled
      if (this.showToastValue) {
        this.showToastNotification(`Copied to clipboard: ${displayText}`);
      }

      // Revert back after 2 seconds
      setTimeout(() => {
        button.innerHTML = originalInnerHTML;
      }, 2000);
    }).catch(err => {
      console.error('Could not copy text: ', err);
      // Show error toast
      this.showToastNotification('Failed to copy to clipboard', 'error');
    });
  }
  
  showToastNotification(message, type = 'success') {
    // Create toast element
    const toast = document.createElement('div');
    toast.className = `fixed bottom-4 right-4 px-4 py-2 rounded-lg shadow-lg z-50 transform transition-all duration-300 ease-in-out translate-y-full opacity-0 ${type === 'success' ? 'bg-green-500' : 'bg-red-500'} text-white`;
    toast.textContent = message;
    
    // Add to DOM
    document.body.appendChild(toast);
    
    // Trigger animation
    setTimeout(() => {
      toast.classList.remove('translate-y-full', 'opacity-0');
    }, 10);
    
    // Remove after duration
    setTimeout(() => {
      toast.classList.add('translate-y-full', 'opacity-0');
      setTimeout(() => {
        document.body.removeChild(toast);
      }, 300); // Give time for animation to complete
    }, this.toastDurationValue);
  }
}
