require "rails_helper"

RSpec.describe(Proponent, type: :model) do
  let(:user) { create(:user) }

  describe "validations" do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_presence_of(:cpf)) }
    it { is_expected.to(validate_presence_of(:user).with_message("#{I18n.t("errors.messages.required")}")) }
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
      subject.phones = ["(11) 9999-9999", "(11) 99999-9999"]

      expect(subject.residential_phone).to(eq("(11) 9999-9999"))
    end
  end

  describe "#residential_phone=" do
    it "returns the first phone" do
      subject.residential_phone = "(11) 9999-9999"

      expect(subject.phones).to(eq(["(11) 9999-9999"]))
    end
  end

  describe "#mobile_phone" do
    it "returns the second phone" do
      subject.phones = ["(11) 9999-9999", "(11) 99999-9999"]

      expect(subject.mobile_phone).to(eq("(11) 99999-9999"))
    end
  end

  describe "#mobile_phone=" do
    it "returns the second phone" do
      subject.mobile_phone = "(11) 99999-9999"

      expect(subject.phones).to(eq([nil, "(11) 99999-9999"]))
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
      expect(Proponent.data_for_chart).to(eq([2, 3, 0, 0]))
    end
  end

  describe "calculate_inss_discount" do
    it "calculates the correct INSS discount for different salary ranges", :aggregate_failures do
      expect(Proponent.calculate_inss_discount("1.000,00")).to(eq(75.0))
      expect(Proponent.calculate_inss_discount("1.500,00")).to(eq(119.32))
      expect(Proponent.calculate_inss_discount("2.000,00")).to(eq(164.32))
      expect(Proponent.calculate_inss_discount("3.000,00")).to(eq(281.62800000000004))
      expect(Proponent.calculate_inss_discount("4.000,00")).to(eq(402.804))
      expect(Proponent.calculate_inss_discount("7.000,00")).to(eq(713.1))
    end
  end

  describe "parse_salary" do
    it "parses salary string to float" do
      expect(Proponent.parse_salary("1.000,50")).to(eq(1000.5))
      expect(Proponent.parse_salary("2.500")).to(eq(2500.0))
    end
  end
end
