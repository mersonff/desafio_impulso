# frozen_string_literal: true

FactoryBot.define do
  factory :proponent do
    name { "MyString" }
    cpf { "MyString" }
    birth_date { "2023-12-30" }
    salary { "9.99" }
  end
end
