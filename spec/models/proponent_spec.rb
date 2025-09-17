# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Proponent, type: :model) do
  subject(:proponent) { described_class.new }

  let(:user) { create(:user) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_presence_of(:cpf)) }
    it { is_expected.to(validate_presence_of(:user).with_message(I18n.t("errors.messages.required").to_s)) }
    it { is_expected.to(allow_value("042.094.483-46").for(:cpf)) }
  end

  describe "associations" do
    it { is_expected.to(belong_to(:user)) }
    it { is_expected.to(have_many(:addresses).dependent(:destroy)) }
  end

  describe "nested attributes" do
    it { is_expected.to(accept_nested_attributes_for(:addresses).allow_destroy(true)) }
  end

  describe "#residential_phone" do
    it "returns the first phone" do
      proponent.phones = ["(11) 9999-9999", "(11) 99999-9999"]

      expect(proponent.residential_phone).to(eq("(11) 9999-9999"))
    end
  end

  describe "#residential_phone=" do
    it "returns the first phone" do
      proponent.residential_phone = "(11) 9999-9999"

      expect(proponent.phones).to(eq(["(11) 9999-9999"]))
    end
  end

  describe "#mobile_phone" do
    it "returns the second phone" do
      proponent.phones = ["(11) 9999-9999", "(11) 99999-9999"]

      expect(proponent.mobile_phone).to(eq("(11) 99999-9999"))
    end
  end

  describe "#mobile_phone=" do
    it "returns the second phone" do
      proponent.mobile_phone = "(11) 99999-9999"

      expect(proponent.phones).to(eq([nil, "(11) 99999-9999"]))
    end
  end

  describe "last_address" do
    it "returns the last address" do
      proponent = create(:proponent)
      address2 = create(:address, proponent: proponent)

      expect(proponent.last_address).to(eq(address2))
    end
  end

  describe "#data_for_chart" do
    before do
      create_list(:proponent, 2, salary: 1000)
      create_list(:proponent, 3, salary: 1500)
    end

    it "returns the correct data for the chart" do
      expect(described_class.data_for_chart).to(eq([2, 3, 0, 0]))
    end
  end

  describe "calculate_inss_discount", :aggregate_failures do
    it "calculates the correct INSS discount for different salary ranges", :aggregate_failures do
      expect(described_class.calculate_inss_discount("1.000,00")).to(eq(75.0))
      expect(described_class.calculate_inss_discount("1.500,00")).to(eq(113.82))
      expect(described_class.calculate_inss_discount("2.000,00")).to(eq(158.82))
      expect(described_class.calculate_inss_discount("3.000,00")).to(eq(258.81))
      expect(described_class.calculate_inss_discount("4.000,00")).to(eq(378.81))
      expect(described_class.calculate_inss_discount("7.000,00")).to(eq(798.81))
    end
  end
end
