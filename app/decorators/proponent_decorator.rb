# frozen_string_literal: true

class ProponentDecorator < Draper::Decorator
  delegate_all

  def salary
    h.number_with_precision(object.salary, precision: 2, separator: ",", delimiter: ".")
  end

  def inss_discount
    h.number_with_precision(object.inss_discount, precision: 2, separator: ",", delimiter: ".")
  end
end
