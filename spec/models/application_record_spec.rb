# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationRecord, type: :model) do
  describe "abstract class" do
    it "is abstract" do
      expect(described_class.abstract_class).to(be(true))
    end
  end
end
