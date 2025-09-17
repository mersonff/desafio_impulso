import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "spinner", "text"]

  connect() {
    // Listen for form submissions
    const form = this.element.closest("form")
    if (form) {
      form.addEventListener("submit", this.showLoading.bind(this))
    }

    // Listen for turbo events
    document.addEventListener("turbo:submit-start", this.showLoading.bind(this))
    document.addEventListener("turbo:submit-end", this.hideLoading.bind(this))
  }

  showLoading() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
    }

    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("d-none")
    }

    if (this.hasTextTarget) {
      this.originalText = this.textTarget.textContent
      this.textTarget.textContent = "Carregando..."
    }

    // Add loading overlay to forms
    const form = this.element.closest("form")
    if (form && !form.querySelector(".loading-overlay")) {
      const overlay = document.createElement("div")
      overlay.className = "loading-overlay"
      overlay.innerHTML = '<div class="spinner"></div>'
      form.style.position = "relative"
      form.appendChild(overlay)
    }
  }

  hideLoading() {
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = false
    }

    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("d-none")
    }

    if (this.hasTextTarget && this.originalText) {
      this.textTarget.textContent = this.originalText
    }

    // Remove loading overlay
    const form = this.element.closest("form")
    if (form) {
      const overlay = form.querySelector(".loading-overlay")
      if (overlay) {
        overlay.remove()
      }
    }
  }
}