# frozen_string_literal: true

class Proponent < ApplicationRecord
  serialize :phones, coder: JSON
  has_many :addresses, dependent: :destroy

  belongs_to :user

  validates :name, presence: true
  validates :cpf, presence: true, cpf: true

  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true

  broadcasts_to ->(_proponent) { "proponents" }, inserts_by: :prepend

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
end
