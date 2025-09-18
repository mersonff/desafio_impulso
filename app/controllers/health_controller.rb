# frozen_string_literal: true

class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    render(
      json: {
        status: "healthy",
        timestamp: Time.current.iso8601,
        rails_env: Rails.env,
      },
      status: :ok,
    )
  end

  def deep
    checks = {
      database: database_check,
      redis: redis_check,
      timestamp: Time.current.iso8601,
    }

    status = checks.values.all? ? :ok : :service_unavailable

    render(
      json: {
        status: status == :ok ? "healthy" : "unhealthy",
        checks: checks,
      },
      status: status,
    )
  end

  private

  def database_check
    ActiveRecord::Base.connection.execute("SELECT 1")
    true
  rescue StandardError => e
    Rails.logger.error("Database health check failed: #{e.message}")
    false
  end

  def redis_check
    Redis.current.ping == "PONG"
  rescue StandardError => e
    Rails.logger.error("Redis health check failed: #{e.message}")
    false
  end
end
