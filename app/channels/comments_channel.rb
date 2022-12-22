class CommentsChannel < ApplicationCable::Channel
  def subscribed
    # stop_all_streams
    stream_from "comment_channel_for_#{params[:post_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_from "comment_channel_for_#{params[:post_id]}"
  end
end
