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

  # Patch específico para ActionCable Redis adapter
  Rails.application.config.after_initialize do
    if defined?(ActionCable)
      # Intercepta conexões Redis do ActionCable
      ActionCable::SubscriptionAdapter::Redis.class_eval do
        def redis_connection_for_subscriptions
          @redis_connection_for_subscriptions ||= ::Redis.new(
            url: ActionCable.server.config.cable[:url] || ActionCable.server.config.cable["url"],
            driver: :ruby,
            id: nil  # Remove client name que causa problemas
          )
        end

        def redis_connection_for_broadcasts
          @redis_connection_for_broadcasts ||= ::Redis.new(
            url: ActionCable.server.config.cable[:url] || ActionCable.server.config.cable["url"],
            driver: :ruby,
            id: nil  # Remove client name que causa problemas
          )
        end
      end
    end
  end
end