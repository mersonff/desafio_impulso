import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { userId: String }

  connect() {
    this.consumer = createConsumer();
    this.currentJobId = null;
    this.setupDiscountChannel();
  }

  setupDiscountChannel() {
    this.subscription = this.consumer.subscriptions.create(
      {
        channel: "DiscountCalculationChannel",
        user_id: this.userIdValue
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

    // Mostra estado de loading
    this.showLoading();

    const url = `/proponents/calculate_inss_discount?salary=${salary}`;

    fetch(url)
      .then(response => {
        if (!response.ok) {
          throw new Error('Erro ao calcular desconto');
        }
        return response.json();
      })
      .then(data => {
        if (data.status === 'processing') {
          this.currentJobId = data.job_id;
          // Mantém loading até receber resultado via WebSocket
        } else if (data.inss_discount != null) {
          this.parseDiscount(data);
        }
      })
      .catch(error => {
        console.error('Erro:', error);
        this.hideLoading();
        const inssDiscount = document.getElementById('proponent_inss_discount');
        inssDiscount.value = '';
      });
  }

  showLoading() {
    const inssDiscount = document.getElementById('proponent_inss_discount');
    inssDiscount.value = 'Calculando...';
    inssDiscount.classList.add('bg-light');
    inssDiscount.setAttribute('readonly', true);
  }

  hideLoading() {
    const inssDiscount = document.getElementById('proponent_inss_discount');
    inssDiscount.classList.remove('bg-light');
    inssDiscount.removeAttribute('readonly');
  }

  parseDiscount(data) {
    this.hideLoading();
    const inssDiscount = document.getElementById('proponent_inss_discount');
    const discount = Math.floor(data.inss_discount * 100) / 100;
    inssDiscount.value = discount.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2, round: 'floor' });
  }

  _connected() {
    console.log("Connected to discount calculation channel");
  }

  _received(data) {
    // Verifica se é o resultado do job atual
    if (data.job_id === this.currentJobId) {
      this.parseDiscount(data);
      this.currentJobId = null;
    }
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe();
    }
  }
}
