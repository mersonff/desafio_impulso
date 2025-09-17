import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.createBackdrop()
    document.body.style.overflow = "hidden"

    // Add entrance animation
    requestAnimationFrame(() => {
      if (this.backdrop) {
        this.backdrop.classList.add("show")
      }
      this.element.querySelector(".modal-dialog")?.classList.add("show")
    })
  }

  disconnect() {
    document.body.style.overflow = "auto"
    this.removeBackdrop()
  }

  createBackdrop() {
    // Remove any existing backdrop
    this.removeBackdrop()

    // Create new backdrop
    this.backdrop = document.createElement("div")
    this.backdrop.className = "modal-backdrop fade"
    this.backdrop.style.zIndex = "1040"

    document.body.appendChild(this.backdrop)
  }

  removeBackdrop() {
    const existingBackdrop = document.querySelector(".modal-backdrop")
    if (existingBackdrop) {
      existingBackdrop.remove()
    }
  }

  close(event) {
    if (event) {
      event.preventDefault()
      // Only close on ESC key, not other events
      if (event.type === 'keydown' && event.key !== 'Escape') {
        return
      }
    }

    // Add exit animation
    if (this.backdrop) {
      this.backdrop.classList.remove("show")
    }

    const modalDialog = this.element.querySelector(".modal-dialog")
    if (modalDialog) {
      modalDialog.classList.remove("show")
    }

    // Wait for animation before cleaning up
    setTimeout(() => {
      // Clear the modal turbo frame
      const modalFrame = document.getElementById("modal")
      if (modalFrame) {
        modalFrame.innerHTML = ""
      }

      // Navigate back in history
      if (window.history.length > 1) {
        window.history.back()
      }
    }, 150) // Bootstrap modal transition duration
  }

}