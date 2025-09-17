import { Controller } from "@hotwired/stimulus"
import { Dropdown } from "bootstrap"

export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    // Try to use Bootstrap dropdown first
    try {
      this.dropdown = new Dropdown(this.toggleTarget)
    } catch (error) {
      // Fallback to custom implementation
      console.log("Bootstrap dropdown not available, using fallback")
      this.setupFallback()
    }
  }

  setupFallback() {
    // Close dropdown when clicking outside
    document.addEventListener("click", this.closeOnClickOutside.bind(this))
  }

  disconnect() {
    if (this.dropdown) {
      this.dropdown.dispose()
    }
    document.removeEventListener("click", this.closeOnClickOutside.bind(this))
  }

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()

    if (this.dropdown) {
      this.dropdown.toggle()
    } else {
      this.fallbackToggle()
    }
  }

  fallbackToggle() {
    const isOpen = this.menuTarget.classList.contains("show")

    // Close all other dropdowns first
    document.querySelectorAll(".dropdown-menu.show").forEach(menu => {
      menu.classList.remove("show")
    })

    // Toggle current dropdown
    if (!isOpen) {
      this.menuTarget.classList.add("show")
      this.toggleTarget.setAttribute("aria-expanded", "true")
    } else {
      this.menuTarget.classList.remove("show")
      this.toggleTarget.setAttribute("aria-expanded", "false")
    }
  }

  close() {
    if (this.dropdown) {
      this.dropdown.hide()
    } else {
      this.menuTarget.classList.remove("show")
      this.toggleTarget.setAttribute("aria-expanded", "false")
    }
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}