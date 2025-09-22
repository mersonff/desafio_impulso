# frozen_string_literal: true

# Patch para compatibilidade com Redis Memorystore
# Remove comandos incompatíveis que causam falhas

if Rails.env.production?
  # Patch do ActionCable Redis adapter para não usar CLIENT SETNAME
  module ActionCable
    module SubscriptionAdapter
      class Redis < Base
        class Listener
          private

          def redis_connection_for_subscriptions
            @redis_connection_for_subscriptions ||= @adapter.redis_connection_for_subscriptions.tap do |redis|
              # Remove client name setting que causa problemas no Memorystore
              begin
                # Tenta fazer ping simples em vez de setname
                redis.ping
              rescue => e
                Rails.logger.warn "Redis connection test failed: #{e.message}"
              end
            end
          end
        end
      end
    end
  end

  # Configuração do Redis para ActionCable sem comandos problemáticos
  ActionCable.server.config.cable = {
    adapter: 'redis',
    url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" },
    channel_prefix: 'dasafio_impulso_production',
    # Configurações compatíveis com Memorystore
    driver: :ruby,
    reconnect_attempts: 3,
    reconnect_delay: 1.0,
    reconnect_delay_max: 30.0
  }
end