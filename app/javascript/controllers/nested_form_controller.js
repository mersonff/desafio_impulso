import NestedForm from 'stimulus-rails-nested-form'

export default class extends NestedForm {
  connect() {
    super.connect()
    console.log('Do what you want here.')
  }

  cancel(event) {
    event.preventDefault();
    const form = this.element.closest('form');
    const frameId = form.closest('turbo-frame').id;
    
    // Limpa o form
    if (frameId === 'new_proponent') {
      Turbo.visit('/proponents', { action: 'replace' });
    } else {
      const proponentId = frameId.replace('proponent_', '');
      Turbo.visit(`/proponents/${proponentId}`, { action: 'replace' });
    }
  }
}
