import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("click", this.confirm.bind(this))
  }

  confirm(event) {
    if (!confirm(this.element.getAttribute("data-confirm"))) {
      event.preventDefault();
      event.stopPropagation();
    }
  }
}
