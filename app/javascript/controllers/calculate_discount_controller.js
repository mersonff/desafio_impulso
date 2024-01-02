import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  connect() {
    this.consumer = createConsumer();
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: "WorkerChannel",
      },
      {
        connected: this._connected.bind(this),
        received: this._received.bind(this),
      }
    );
  }

  calculate(event) {
    event.preventDefault();
    const salary = event.target.value;

    const url = `/proponents/calculate_inss_discount?salary=${salary}`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        const inssDiscount = document.getElementById('proponent_inss_discount');

        if(data.inss_discount == null) {
          inssDiscount.value = data.message;
        } else {
          const discount = Math.floor(data.inss_discount * 100) / 100;
          inssDiscount.value = discount.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2, round: 'floor' });
        }
      });
  }

  _connected() {
    console.log("Connected");
  }

  _received(data) {
    const inssDiscount = document.getElementById('proponent_inss_discount');
    const discount = Math.floor(data.result * 100) / 100;
    inssDiscount.value = discount.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2, round: 'floor' });
  }
}
