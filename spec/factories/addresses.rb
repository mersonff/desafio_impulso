# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    proponent { nil }
    street { "MyString" }
    number { "MyString" }
    neighborhood { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
  end
end
