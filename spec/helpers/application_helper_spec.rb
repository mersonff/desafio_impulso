# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationHelper, type: :helper) do
  describe "#bootstrap_flash_class" do
    it "returns the correct class for notice" do
      expect(helper.bootstrap_flash_class(:notice)).to(eq("success"))
    end

    it "returns the correct class for alert" do
      expect(helper.bootstrap_flash_class(:alert)).to(eq("danger"))
    end

    it "returns the correct class for error" do
      expect(helper.bootstrap_flash_class(:error)).to(eq("danger"))
    end

    it "returns the correct class for warning" do
      expect(helper.bootstrap_flash_class(:warning)).to(eq("warning"))
    end

    it "returns the correct class for other types" do
      expect(helper.bootstrap_flash_class(:other)).to(eq("info"))
    end
  end

  describe "#title_for" do
    it "returns the correct title for new record" do
      expect(helper.title_for(create(:proponent))).to(eq("<h2>Editar Proponente</h2>"))
    end

    it "returns the correct title for edit record" do
      expect(helper.title_for(build(:proponent))).to(eq("<h2>Novo Proponente</h2>"))
    end
  end
end
