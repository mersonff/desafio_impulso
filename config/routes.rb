# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :proponents, except: [:show]
  root to: "proponents#index"
end
