class ChatsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "chat_channel"   
  end

  def unsubscribed
    # stop_all_streams
  end
end
