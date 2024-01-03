# frozen_string_literal: true

if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: :environment do
      include FactoryBot::Syntax::Methods

      User.destroy_all

      create(:user, email: "test@test.com", password: "123456", password_confirmation: "123456")

      10.times do |i|
        create(:proponent, name: "Proponent #{i}", user: User.first)
      end
    end
  end
end
