class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "chat_channel_for_#{params[:user_id]}"
  end

  def unsubscribed
    # stop_all_streams
    stop_stream_from "chat_channel_for_#{params[:user_id]}"
  end
end
