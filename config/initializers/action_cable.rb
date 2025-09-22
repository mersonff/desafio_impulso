# frozen_string_literal: true

# Configuração do ActionCable para compatibilidade com Redis Memorystore
Rails.application.configure do
  if Rails.env.production?
    # Usar um pool de conexões Redis simples sem comandos avançados
    config.action_cable.adapter = :redis
    config.action_cable.url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }
    config.action_cable.channel_prefix = "dasafio_impulso_production"

    # Configurar para não usar CLIENT SETNAME que causa problemas no Memorystore
    ActionCable.server.config.disable_request_forgery_protection = false
    ActionCable.server.config.allowed_request_origins = [
      /https?:\/\/.*\.run\.app/,
      /https?:\/\/.*\.googleapis\.com/
    ]
  end
end