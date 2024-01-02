# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :proponent

  validates :zip_code, presence: true

  def to_s
    "#{street}, #{number} - #{neighborhood}, #{city}/#{state}"
  end
end
