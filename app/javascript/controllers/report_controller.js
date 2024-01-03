// app/javascript/controllers/proponents/_report_controller.js
import { Controller } from "@hotwired/stimulus";
import Chart from 'chart.js/auto';

export default class extends Controller {
  connect() {
    console.log('report_controller');
    this.fetchDataAndRenderChart();
  }

  async fetchDataAndRenderChart() {
    try {
      const response = await fetch('/proponents/report_data');
      const data = await response.json();

      if (data) {
        this.renderChart(data);
      } else {
        console.error('Erro ao obter dados do servidor.');
      }
    } catch (error) {
      console.error('Erro na requisição:', error);
    }
  }

  renderChart(data) {
    const ctx = document.getElementById('proponentChart').getContext('2d');
    const chartData = {
      labels: data.labels,
      datasets: [{
        label: 'Número de Proponentes',
        data: data.values,
        backgroundColor: [
          'rgba(255, 99, 132, 0.5)',
          'rgba(255, 205, 86, 0.5)',
          'rgba(75, 192, 192, 0.5)',
          'rgba(54, 162, 235, 0.5)',
        ],
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(255, 205, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(54, 162, 235, 1)',
        ],
        borderWidth: 1,
      }],
    };

    const config = {
      type: 'bar',
      data: chartData,
    };

    new Chart(ctx, config);
  }
}
