# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :proponents, except: [:show] do
    resources :addresses, except: [:show, :index]
    get "report_data", on: :collection
    get "report", on: :collection
  end
  root to: "proponents#index"
end
