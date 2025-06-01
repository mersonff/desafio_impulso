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

    if (!salary) {
      const inssDiscount = document.getElementById('proponent_inss_discount');
      inssDiscount.value = '';
      return;
    }

    const url = `/proponents/calculate_inss_discount?salary=${salary}`;

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro ao calcular desconto');
        }
        return response.json();
      })
      .then(data => {
        const inssDiscount = document.getElementById('proponent_inss_discount');
        if (data.inss_discount != null) {
          this.parseDiscount(data);
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        const inssDiscount = document.getElementById('proponent_inss_discount');
        inssDiscount.value = '';
      });
  }

  parseDiscount(data) {
    const inssDiscount = document.getElementById('proponent_inss_discount');
    const discount = Math.floor(data.inss_discount * 100) / 100;
    inssDiscount.value = discount.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2, round: 'floor' });
  }

  _connected() {
    console.log("Connected");
  }

  _received(data) {
    this.parseDiscount(data)
  }
}
