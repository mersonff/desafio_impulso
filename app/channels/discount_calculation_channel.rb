# frozen_string_literal: true

class DiscountCalculationChannel < ApplicationCable::Channel
  def subscribed
    user_id = params[:user_id]

    if user_id.present?
      stream_from "discount_calculation_#{user_id}"
      Rails.logger.info "User #{user_id} subscribed to discount calculation channel"
    else
      reject
    end
  end

  def unsubscribed
    Rails.logger.info "User unsubscribed from discount calculation channel"
  end
end