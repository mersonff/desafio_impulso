# frozen_string_literal: true

class CalculateDiscountJob
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(salary)
    result = Proponent.calculate_inss_discount(salary)

    ActionCable.server.broadcast(
      "WorkerChannel",
      { result: result },
    )
  end
end
