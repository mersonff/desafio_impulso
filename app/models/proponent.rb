# frozen_string_literal: true

class Proponent < ApplicationRecord
  serialize :phones, coder: JSON
  has_many :addresses, dependent: :destroy

  belongs_to :user

  validates :name, presence: true
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
        Proponent.where(salary: 0..1045).count,
        Proponent.where(salary: 1045.01..2089.60).count,
        Proponent.where(salary: 2089.61..3134.40).count,
        Proponent.where(salary: 3134.41..6101.06).count,
      ]
    end

    def calculate_inss_discount(salary)
      return 0.0 if salary.blank?

      salary = parse_salary(salary)
      result = if salary <= 1045
        salary * 0.075
      elsif salary <= 2089.60
        (salary - 1045) * 0.09 + 78.37
      elsif salary <= 3134.40
        (salary - 2089.60) * 0.12 + 94.01 + 78.37
      elsif salary <= 6101.06
        (salary - 3134.40) * 0.14 + 109.24 + 94.01 + 78.37
      else
        713.10
      end
      result
    end

    def parse_salary(salary)
      salary.delete(".").tr(",", ".").to_f
    end
  end
end
