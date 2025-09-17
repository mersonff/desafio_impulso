# frozen_string_literal: true

require "rails_helper"
require "sidekiq/testing"
Sidekiq::Testing.fake!

RSpec.describe(CalculateDiscountJob, type: :job) do
  Sidekiq::Testing.inline!

  describe "#perform" do
    it "broadcasts the result to WorkerChannel" do
      salary = "4.000,0"
      result = 378.81

      allow(ActionCable.server).to(receive(:broadcast))

      described_class.perform_async(salary)

      expect(ActionCable.server).to(have_received(:broadcast).with(
        "WorkerChannel",
        { inss_discount: result },
      ))
    end
  end
end
