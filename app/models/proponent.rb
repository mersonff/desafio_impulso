# frozen_string_literal: true

class Proponent < ApplicationRecord
  include Searchable

  serialize :phones, coder: JSON
  has_many :addresses, dependent: :destroy

  belongs_to :user

  validates :name, :salary, presence: true
  validates :cpf, presence: true, cpf: true

  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  broadcasts_to ->(_proponent) { "proponents" }, inserts_by: :prepend

  default_scope { order(name: :asc) }

  def residential_phone
    phones&.first
  end

  def residential_phone=(value)
    self.phones ||= []
    self.phones[0] = value
  end

  def mobile_phone
    phones&.second
  end

  def mobile_phone=(value)
    self.phones ||= []
    self.phones[1] = value
  end

  def last_address
    addresses.order(created_at: :desc).first
  end

  class << self
    def data_for_chart
      [
        Proponent.where(salary: 0..1412).count,
        Proponent.where(salary: 1412.01..2666.68).count,
        Proponent.where(salary: 2666.69..4000.03).count,
        Proponent.where(salary: 4000.04..7786.02).count,
      ]
    end

    def calculate_inss_discount(salary)
      InssCalculatorService.new(salary).calculate
    end

    def search(query)
      params = {
        query: {
          multi_match: {
            query: query,
            fields: ["name"],
            fuzziness: "AUTO",
          },
        },
      }

      __elasticsearch__.search(params).records.to_a
    end
  end
end
