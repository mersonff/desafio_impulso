# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  describe "associations" do
    it { is_expected.to(have_many(:proponents).dependent(:destroy)) }
  end

  describe "devise modules" do
    it "includes database_authenticatable module" do
      expect(described_class.devise_modules).to(include(:database_authenticatable))
    end

    it "includes registerable module" do
      expect(described_class.devise_modules).to(include(:registerable))
    end

    it "includes recoverable module" do
      expect(described_class.devise_modules).to(include(:recoverable))
    end

    it "includes rememberable module" do
      expect(described_class.devise_modules).to(include(:rememberable))
    end

    it "includes validatable module" do
      expect(described_class.devise_modules).to(include(:validatable))
    end
  end
end
