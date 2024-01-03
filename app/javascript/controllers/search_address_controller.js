import { Controller } from "@hotwired/stimulus";

// Conecta ao data-controller="search-address"
export default class extends Controller {
  connect() {
    console.log('search_address_controller');
  }

  search(event) {
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
          alert('CEP não encontrado');
        } else {
          const zipCodeFragmentId = zipCodeInput.id.split('attributes_')[1];
          const numberFromId = zipCodeFragmentId.split('_')[0];

          const updateElementValue = (suffix, value) => {
            const relatedElement = document.querySelector(`[id$=_${numberFromId}_${suffix}]`);
            if (relatedElement) {
              relatedElement.value = value;
            }
          };

          updateElementValue('street', data.logradouro);
          updateElementValue('neighborhood', data.bairro);
          updateElementValue('city', data.localidade);
          updateElementValue('state', data.uf);

          const numberElement = document.querySelector(`[id$=_${numberFromId}_number]`);
          if (numberElement) {
            numberElement.focus();
          }
        }
      });
  }
}
