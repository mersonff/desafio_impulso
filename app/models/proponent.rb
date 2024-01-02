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
  end
end
