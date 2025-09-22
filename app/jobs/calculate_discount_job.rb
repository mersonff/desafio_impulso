# frozen_string_literal: true

class CalculateDiscountJob
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(salary, job_id, user_id)
    result = Proponent.calculate_inss_discount(salary)

    ActionCable.server.broadcast(
      "discount_calculation_#{user_id}",
      {
        job_id: job_id,
        status: "completed",
        inss_discount: result,
        message: "Desconto calculado com sucesso!"
      }
    )
  end
end
