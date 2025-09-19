# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  # Sidekiq Web UI (requires authentication)
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  get "health", to: "health#show"
  get "health/deep", to: "health#deep"

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
