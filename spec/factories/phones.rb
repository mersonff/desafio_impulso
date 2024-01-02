# frozen_string_literal: true

FactoryBot.define do
  factory :phone do
    proponent { nil }
    phone_number { "MyString" }
  end
end
