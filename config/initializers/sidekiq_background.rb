# frozen_string_literal: true

# Configura Sidekiq para rodar em background no Cloud Run (apenas no serviço Rails)
if Rails.env.production? && ENV["K_SERVICE"] == "desafio-impulso-rails"
  Rails.application.config.after_initialize do
    # Configurar Sidekiq Redis
    Sidekiq.configure_server do |config|
      config.redis = { url: ENV["REDIS_URL"] }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: ENV["REDIS_URL"] }
    end

    Thread.new do
      Rails.logger.info("🚀 Iniciando Sidekiq worker em background...")

      Sidekiq::Launcher.new(
        "concurrency" => 2,
        "timeout" => 25,
        "queues" => ["default"],
        "verbose" => false,
      ).run
    rescue => e
      Rails.logger.error(e.backtrace.join("\n"))
    end
  end
end
