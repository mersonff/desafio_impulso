import { Controller } from "@hotwired/stimulus"
import IMask from "imask";

const maskOptions = {
  cpf: { mask: "000.000.000-00" },
  currency: {
    mask: Number,
    scale: 2,
    thousandsSeparator: '.',
    radix: ',',
    mapToRadix: [','],
    normalizeZeros: true,
    padFractionalZeros: true,
    min: -9999999999,
    max: 9999999999
  }
}

export default class extends Controller {
  static values = { type: String };

  connect() {
    IMask(this.element, maskOptions[this.typeValue]);
  }
}
