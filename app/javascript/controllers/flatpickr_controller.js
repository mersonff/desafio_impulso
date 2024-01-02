import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt.js";


// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!", this.element);
    flatpickr(".fp_date_time", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
      }
    );

    flatpickr(".fp_date", {
        enableTime: false,
        dateFormat: "d/m/Y",
        locale: Portuguese
      }
    );
  }
}
