import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("mouseenter", this.addHoverEffect.bind(this))
    this.element.addEventListener("mouseleave", this.removeHoverEffect.bind(this))
  }

  addHoverEffect() {
    this.element.style.transform = "translateY(-2px)"
    this.element.style.boxShadow = "0 8px 25px rgba(0,0,0,0.15)"
    this.element.style.transition = "all 0.2s ease-in-out"
  }

  removeHoverEffect() {
    this.element.style.transform = "translateY(0)"
    this.element.style.boxShadow = ""
  }
}