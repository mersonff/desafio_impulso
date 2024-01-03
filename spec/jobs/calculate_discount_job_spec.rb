# spec/jobs/calculate_discount_job_spec.rb

require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe(CalculateDiscountJob, type: :job) do
  # Configuração para que o Sidekiq execute jobs imediatamente no teste
  Sidekiq::Testing.inline!

  describe "#perform" do
    it "broadcasts the result to WorkerChannel" do
      salary = "4.000,0"
      result = 402.804 # Substitua pelo resultado esperado

      # Configuração de expectativa para ActionCable.server.broadcast
      expect(ActionCable.server).to(receive(:broadcast).with(
        "WorkerChannel",
        { result: result },
      ))

      CalculateDiscountJob.perform_async(salary)
    end
  end
end
