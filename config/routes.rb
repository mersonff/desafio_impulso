# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  # Health check endpoint
  get "health", to: "health#show"

  resources :proponents, except: [:show] do
    resources :addresses, except: [:show, :index]
    collection do
      get "report_data"
      get "report"
      get "calculate_inss_discount"
    end
  end
  root to: "proponents#index"
end
