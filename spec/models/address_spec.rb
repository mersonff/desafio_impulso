# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Address, type: :model) do
  it { is_expected.to(belong_to(:proponent)) }

  it { is_expected.to(validate_presence_of(:zip_code)) }

  describe "#to_s" do
    it "returns the address" do
      address = build(
        :address,
        street: "Rua 1",
        number: "123",
        neighborhood: "Bairro 1",
        city: "Cidade 1",
        state: "Estado 1",
        zip_code: "12345-123",
      )

      expect(address.to_s).to(eq("Rua 1, 123 - Bairro 1, Cidade 1/Estado 1, 12345-123"))
    end
  end
end
