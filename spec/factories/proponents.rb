# frozen_string_literal: true

FactoryBot.define do
  factory :proponent do
    sequence(:name) { |n| "Proponent #{n}" }
    user
    cpf { "042.094.483-46" }
    birth_date { "2023-12-30" }
    salary { 1100 }
    inss_discount { 82.5 }
    after(:create) do |proponent|
      proponent.addresses << build(:address, proponent: proponent)
    end
  end
end
