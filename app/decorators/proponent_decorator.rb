# frozen_string_literal: true

class ProponentDecorator < Draper::Decorator
  delegate_all

  def salary
    object.localized.salary
  end

  def inss_discount
    object.localized.inss_discount
  end
end
