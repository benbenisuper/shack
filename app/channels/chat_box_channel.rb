class ChatBoxChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "chat_box_#{params[:chat_box_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
