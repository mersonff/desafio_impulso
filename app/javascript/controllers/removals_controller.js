import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Removals controller connected");
    this.element.addEventListener("animationend", this.remove);
  }

  remove() {
    this.element?.remove();
  }
}
