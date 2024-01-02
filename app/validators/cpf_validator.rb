# frozen_string_literal: true

require "cpf_validator"
class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless CPF.valid?(value)
      record.errors[attribute] << (options[:message] || "is not a valid CPF")
    end
  end
end
