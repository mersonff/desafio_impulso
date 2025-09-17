import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]
  static values = {
    name: String,
    url: String
  }

  connect() {
    this.originalCard = this.element.closest('.col-lg-4, .col-md-6')
  }

  confirm(event) {
    event.preventDefault()

    const result = this.showCustomConfirm()

    if (result) {
      this.performDelete()
    }
  }

  showCustomConfirm() {
    // Create custom modal confirmation
    const modal = document.createElement('div')
    modal.className = 'modal fade show d-block'
    modal.style.backgroundColor = 'rgba(0, 0, 0, 0.5)'
    modal.innerHTML = `
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow">
          <div class="modal-header bg-danger text-white border-0">
            <h5 class="modal-title d-flex align-items-center">
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              Confirmar Exclusão
            </h5>
          </div>
          <div class="modal-body text-center py-4">
            <div class="mb-3">
              <i class="bi bi-person-x display-4 text-danger"></i>
            </div>
            <h6>Tem certeza que deseja excluir?</h6>
            <p class="text-muted mb-0">
              <strong>${this.nameValue}</strong><br>
              <small>Esta ação não pode ser desfeita.</small>
            </p>
          </div>
          <div class="modal-footer border-0 justify-content-center">
            <button type="button" class="btn btn-outline-secondary" data-action="click->delete#cancelDelete">
              <i class="bi bi-x-circle me-1"></i>
              Cancelar
            </button>
            <button type="button" class="btn btn-danger" data-action="click->delete#confirmDelete">
              <i class="bi bi-trash me-1"></i>
              Sim, Excluir
            </button>
          </div>
        </div>
      </div>
    `

    document.body.appendChild(modal)
    this.currentModal = modal

    // Add event listeners
    modal.querySelector('[data-action="click->delete#cancelDelete"]')
         .addEventListener('click', () => this.cancelDelete())
    modal.querySelector('[data-action="click->delete#confirmDelete"]')
         .addEventListener('click', () => this.confirmDelete())

    // Close on outside click
    modal.addEventListener('click', (e) => {
      if (e.target === modal) this.cancelDelete()
    })

    // Close on escape
    document.addEventListener('keydown', this.handleEscape.bind(this))

    return false // Prevent default form submission
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      this.cancelDelete()
    }
  }

  cancelDelete() {
    if (this.currentModal) {
      this.currentModal.remove()
      this.currentModal = null
    }
    document.removeEventListener('keydown', this.handleEscape.bind(this))
  }

  confirmDelete() {
    this.cancelDelete()
    this.performDelete()
  }

  async performDelete() {
    // Add loading state to card
    this.showLoadingState()

    try {
      const response = await fetch(this.urlValue, {
        method: 'DELETE',
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const responseText = await response.text()

        // Process Turbo Stream response first
        if (responseText.includes('turbo-stream')) {
          Turbo.renderStreamMessage(responseText)
        }

        // Add exit animation and grid reflow
        this.animateExitWithReflow()
      } else {
        this.showError('Erro ao excluir o proponente.')
      }
    } catch (error) {
      console.error('Delete error:', error)
      this.showError('Erro de conexão. Tente novamente.')
    }
  }

  showLoadingState() {
    if (this.originalCard) {
      this.originalCard.style.position = 'relative'

      const overlay = document.createElement('div')
      overlay.className = 'loading-overlay'
      overlay.innerHTML = `
        <div class="d-flex flex-column align-items-center">
          <div class="spinner"></div>
          <small class="text-muted mt-2">Excluindo...</small>
        </div>
      `

      this.originalCard.appendChild(overlay)
    }
  }

  animateExitWithReflow() {
    return new Promise((resolve) => {
      if (!this.originalCard) {
        resolve()
        return
      }

      // Get the grid container
      const gridContainer = this.originalCard.parentElement
      const allCards = Array.from(gridContainer.children)

      // Store original positions for reflow animation
      this.storeOriginalPositions(allCards)

      // First, animate the card exit
      this.originalCard.style.transition = 'all 0.3s ease-out'
      this.originalCard.style.transform = 'scale(0.8)'
      this.originalCard.style.opacity = '0'

      setTimeout(() => {
        // Temporarily hide the card to trigger layout reflow
        this.originalCard.style.display = 'none'

        // Get new positions after layout reflow
        const remainingCards = allCards.filter(card => card !== this.originalCard)

        // Animate remaining cards to their new positions
        this.animateReflow(remainingCards).then(() => {
          resolve()
        })
      }, 300)
    })
  }

  storeOriginalPositions(cards) {
    cards.forEach(card => {
      const rect = card.getBoundingClientRect()
      card.dataset.originalTop = rect.top
      card.dataset.originalLeft = rect.left
    })
  }

  animateReflow(cards) {
    return new Promise((resolve) => {
      // Add transition to all remaining cards
      cards.forEach(card => {
        card.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)'
      })

      // Force layout recalculation
      requestAnimationFrame(() => {
        cards.forEach(card => {
          const rect = card.getBoundingClientRect()
          const originalTop = parseFloat(card.dataset.originalTop)
          const originalLeft = parseFloat(card.dataset.originalLeft)

          const deltaY = originalTop - rect.top
          const deltaX = originalLeft - rect.left

          // Apply reverse transform to start from original position
          if (deltaY !== 0 || deltaX !== 0) {
            card.style.transform = `translate(${deltaX}px, ${deltaY}px)`

            // Animate to final position
            requestAnimationFrame(() => {
              card.style.transform = 'translate(0, 0)'
            })
          }
        })

        // Clean up after animation
        setTimeout(() => {
          cards.forEach(card => {
            card.style.transition = ''
            card.style.transform = ''
            delete card.dataset.originalTop
            delete card.dataset.originalLeft
          })
          resolve()
        }, 400)
      })
    })
  }

  showError(message) {
    // Remove loading overlay
    const overlay = this.originalCard?.querySelector('.loading-overlay')
    if (overlay) overlay.remove()

    // Show error toast
    const toast = document.createElement('div')
    toast.className = 'toast align-items-center text-bg-danger border-0 show position-fixed top-0 end-0 m-3'
    toast.style.zIndex = '1100'
    toast.innerHTML = `
      <div class="d-flex">
        <div class="toast-body d-flex align-items-center">
          <i class="bi bi-exclamation-triangle-fill me-2"></i>
          ${message}
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
      </div>
    `

    document.body.appendChild(toast)

    // Auto remove after 5 seconds
    setTimeout(() => {
      toast.remove()
    }, 5000)
  }
}