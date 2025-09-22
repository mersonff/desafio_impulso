# frozen_string_literal: true

# Patch para compatibilidade com Redis Memorystore
# Intercepta comandos problemáticos do ActionCable

if Rails.env.production?
  # Patch do Redis client para ignorar comandos CLIENT SETNAME
  class Redis
    class Client
      alias_method :original_call, :call

      def call(command)
        # Ignora comando CLIENT SETNAME que causa problemas no Memorystore
        if command.is_a?(Array) && command.first.to_s.upcase == 'CLIENT' && command[1].to_s.upcase == 'SETNAME'
          # Log apenas se Rails estiver disponível
          if defined?(Rails) && Rails.respond_to?(:logger)
            Rails.logger.debug "Ignoring CLIENT SETNAME command for Memorystore compatibility"
          end
          return 'OK'
        end

        original_call(command)
      end
    end
  end
end