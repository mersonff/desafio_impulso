# frozen_string_literal: true

# Configuração do ActionCable para compatibilidade com Redis Memorystore
if Rails.env.production?
  Rails.application.configure do
    # Configurar ActionCable para usar Redis sem comandos problemáticos
    config.action_cable.disable_request_forgery_protection = false
    config.action_cable.allowed_request_origins = [
      /https?:\/\/.*\.run\.app/,
      /https?:\/\/.*\.googleapis\.com/
    ]
  end
end