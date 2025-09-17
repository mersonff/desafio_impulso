import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

export default class extends Controller {
  connect() {
    const toast = new Toast(this.element, {
      delay: 5000,
      autohide: true
    })
    toast.show()
  }

  remove() {
    this.element.remove()
  }
}