import { Controller } from "@hotwired/stimulus";

// Conecta ao data-controller="search-address"
export default class extends Controller {
  connect() {
    console.log('search_address_controller');
  }

  search(event) {
    // Don't prevent default or stop propagation - let normal input behavior continue
    console.log('search_address');
    const zipCodeInput = event.currentTarget;

    const cep = zipCodeInput.value;

    if (cep.length < 9) {
      return;
    }

    const url = `https://viacep.com.br/ws/${cep}/json/`;

    fetch(url)
      .then(response => response.json())
      .then(data => {
        console.log(data);
        if (data.erro) {
          // Use a more subtle notification instead of alert
          this.showNotification('CEP não encontrado', 'error');
        } else {
          const zipCodeFragmentId = zipCodeInput.id.split('attributes_')[1];
          const numberFromId = zipCodeFragmentId.split('_')[0];

          const updateElementValue = (suffix, value) => {
            const relatedElement = document.querySelector(`[id$=_${numberFromId}_${suffix}]`);
            if (relatedElement) {
              relatedElement.value = value;
              // Dispatch input event to trigger any other controllers
              relatedElement.dispatchEvent(new Event('input', { bubbles: true }));
            }
          };

          updateElementValue('street', data.logradouro);
          updateElementValue('neighborhood', data.bairro);
          updateElementValue('city', data.localidade);
          updateElementValue('state', data.uf);

          const numberElement = document.querySelector(`[id$=_${numberFromId}_number]`);
          if (numberElement) {
            // Use setTimeout to avoid any timing issues with focus
            setTimeout(() => {
              numberElement.focus();
            }, 100);
          }

          this.showNotification('Endereço preenchido automaticamente', 'success');
        }
      })
      .catch(error => {
        console.error('Erro ao buscar CEP:', error);
        this.showNotification('Erro ao buscar CEP', 'error');
      });
  }

  showNotification(message, type) {
    // Create a subtle notification without using alert
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} alert-dismissible fade show position-fixed`;
    notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    notification.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;

    document.body.appendChild(notification);

    // Auto remove after 3 seconds
    setTimeout(() => {
      if (notification.parentNode) {
        notification.remove();
      }
    }, 3000);
  }
}
