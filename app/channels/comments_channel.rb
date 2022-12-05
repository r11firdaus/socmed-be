class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "comment_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
