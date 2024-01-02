# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "username@example.com" }
    password { "password" }

    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { "123123" }
    password_confirmation { "123123" }
    confirmed_at { Time.zone.now }
    after(:create) do |user|
      create(:address, user: user)
    end
  end
end
