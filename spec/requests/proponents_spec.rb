# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ProponentsController, type: :request) do
  before do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  describe "GET /index" do
    it "returns http success" do
      get(proponents_path)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get(new_proponent_path)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get(edit_proponent_path(create(:proponent)))
      expect(response).to(have_http_status(:success))
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post(proponents_path, params: { proponent: attributes_for(:proponent) })
      expect(response).to(have_http_status(:redirect))
    end

    it "returns http success when turbo_stream" do
      post(
        proponents_path,
        params: { proponent: attributes_for(:proponent) },
        headers: { "Accept": "text/vnd.turbo-stream.html" },
      )
      expect(response).to(have_http_status(:success))
    end

    it "returns unprocessable_entity when invalid" do
      post(
        proponents_path,
        params: { proponent: attributes_for(:proponent).except(:name).merge(name: "") },
      )
      expect(response).to(have_http_status(:not_acceptable))
    end
  end

  describe "PUT /update" do
    it "returns http success" do
      put(proponent_path(create(:proponent)), params: { proponent: attributes_for(:proponent) })
      expect(response).to(have_http_status(:redirect))
    end

    it "returns http success when turbo_stream" do
      put(
        proponent_path(create(:proponent)),
        params: { proponent: attributes_for(:proponent) },
        headers: { "Accept": "text/vnd.turbo-stream.html" },
      )
      expect(response).to(have_http_status(:success))
    end

    it "returns unprocessable_entity when invalid" do
      put(
        proponent_path(create(:proponent)),
        params: { proponent: attributes_for(:proponent).except(:name).merge(name: "") },
      )
      expect(response).to(have_http_status(:not_acceptable))
    end
  end

  describe "DELETE /destroy" do
    it "returns http success" do
      delete(proponent_path(create(:proponent)))
      expect(response).to(have_http_status(:redirect))
    end

    it "returns http success when turbo_stream" do
      delete(
        proponent_path(create(:proponent)),
        headers: { "Accept": "text/vnd.turbo-stream.html" },
      )
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /report_data" do
    it "returns http success" do
      get(report_data_proponents_path)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /report" do
    it "returns http success" do
      get(report_proponents_path)
      expect(response).to(have_http_status(:success))
    end
  end

  describe "GET /calculate_inss_discount" do
    it "returns http success" do
      get(calculate_inss_discount_proponents_path)
      expect(response).to(have_http_status(:success))

      Sidekiq::Testing.fake! { get(calculate_inss_discount_proponents_path) }
      expect(CalculateDiscountJob.jobs.size).to(eq(1))
    end
  end
end
