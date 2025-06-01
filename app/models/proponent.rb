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
        Proponent.where(salary: 0..1045).count,
        Proponent.where(salary: 1045.01..2089.60).count,
        Proponent.where(salary: 2089.61..3134.40).count,
        Proponent.where(salary: 3134.41..6101.06).count,
      ]
    end

    def calculate_inss_discount(salary)
      return 0.0 if salary.blank?

      salary = parse_salary(salary)
      
      # Se o salário for maior que o teto, calcula o desconto até o teto
      if salary > 7786.02
        return 876.97 # Teto do INSS 2023
      end

      # Calcula o desconto progressivo por faixas
      result = 0.0

      # 1ª faixa: até R$ 1.412,00 (7,5%)
      if salary > 1412
        result += 1412 * 0.075
      else
        result += salary * 0.075
        return (result * 100).floor / 100.0
      end

      # 2ª faixa: de R$ 1.412,01 até R$ 2.666,68 (9%)
      if salary > 2666.68
        result += (2666.68 - 1412) * 0.09
      else
        result += (salary - 1412) * 0.09
        return (result * 100).floor / 100.0
      end

      # 3ª faixa: de R$ 2.666,69 até R$ 4.000,03 (12%)
      if salary > 4000.03
        result += (4000.03 - 2666.68) * 0.12
      else
        result += (salary - 2666.68) * 0.12
        return (result * 100).floor / 100.0
      end

      # 4ª faixa: de R$ 4.000,04 até R$ 7.786,02 (14%)
      if salary > 7786.02
        result += (7786.02 - 4000.03) * 0.14
      else
        result += (salary - 4000.03) * 0.14
      end

      # Arredonda para 2 casas decimais
      (result * 100).floor / 100.0
    end

    def parse_salary(salary)
      salary.delete(".").tr(",", ".").to_f
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
