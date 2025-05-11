import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-validation"
export default class extends Controller {
  static targets = ["field"]

  connect() {
    console.log("Form validation controller connected")
  }

  validateUrl(event) {
    const urlField = event.target
    if (urlField.value) {
      // Add http:// prefix if no protocol is present
      if (!urlField.value.match(/^https?:\/\//i)) {
        urlField.value = `http://${urlField.value}`
      }
    }
  }

  generateRandomSlug() {
    // Find the slug field among targets
    const slugField = this.fieldTargets.find(field => field.name === "short_url[slug]")
    
    if (slugField) {
      // Generate a random slug (similar to the model's logic but in JS)
      const chars = 'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
      let result = ''
      for (let i = 0; i < 6; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      
      slugField.value = result
      
      // Add visual feedback
      slugField.classList.add('bg-green-50')
      setTimeout(() => {
        slugField.classList.remove('bg-green-50')
      }, 800)
    }
  }
}
