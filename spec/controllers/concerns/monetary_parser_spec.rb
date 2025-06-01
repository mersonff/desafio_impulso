# frozen_string_literal: true

require "rails_helper"

class DummyClass
  include MonetaryParser
end

RSpec.describe MonetaryParser do
  let(:dummy) { DummyClass.new }

  describe "#parse_monetary_value" do
    it "converte string BR para float" do
      expect(dummy.send(:parse_monetary_value, "1.234,56")).to eq(1234.56)
    end

    it "retorna nil para valores em branco" do
      expect(dummy.send(:parse_monetary_value, "")).to be_nil
      expect(dummy.send(:parse_monetary_value, nil)).to be_nil
    end
  end

  describe "#parse_monetary_params" do
    it "parseia salary e inss_discount" do
      params = {
        salary: "1.234,56",
        inss_discount: "123,45"
      }
      result = dummy.send(:parse_monetary_params, params)
      expect(result[:salary]).to eq(1234.56)
      expect(result[:inss_discount]).to eq(123.45)
    end

    it "mantém outros atributos inalterados" do
      params = {
        name: "John",
        salary: "1.234,56"
      }
      result = dummy.send(:parse_monetary_params, params)
      expect(result[:name]).to eq("John")
      expect(result[:salary]).to eq(1234.56)
    end

    it "retorna nil params inalterados" do
      expect(dummy.send(:parse_monetary_params, nil)).to be_nil
    end
  end
end