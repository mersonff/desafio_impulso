# frozen_string_literal: true

class WorkerChannel < ApplicationCable::Channel
  def subscribed
    stream_from("WorkerChannel")
  end

  def receive(data)
    ActionCable.server.broadcast("WorkerChannel", {
      message: data["message"].upcase,
    })
  end
end
