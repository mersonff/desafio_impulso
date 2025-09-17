import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    animation: String,
    duration: { type: Number, default: 300 },
    delay: { type: Number, default: 0 }
  }

  connect() {
    setTimeout(() => {
      this.animate()
    }, this.delayValue)
  }

  animate() {
    const animation = this.animationValue || "fadeIn"

    this.element.style.animation = `${animation} ${this.durationValue}ms ease-out`

    // Add class for CSS animations
    this.element.classList.add(`animate-${animation}`)

    // Remove animation after completion
    setTimeout(() => {
      this.element.style.animation = ""
      this.element.classList.remove(`animate-${animation}`)
    }, this.durationValue)
  }

  // Method to trigger animations programmatically
  trigger(animationName = null) {
    if (animationName) {
      this.animationValue = animationName
    }
    this.animate()
  }
}