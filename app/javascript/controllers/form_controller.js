import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  cancel(event) {
    event.preventDefault();
    const frameId = this.element.closest('turbo-frame').id;
    
    if (frameId === 'new_proponent') {
      Turbo.visit('/proponents', { action: 'replace' });
    } else {
      const proponentId = frameId.replace('proponent_', '');
      Turbo.visit(`/proponents/${proponentId}`, { action: 'replace' });
    }
  }
} 