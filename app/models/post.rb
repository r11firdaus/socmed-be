class Post < ApplicationRecord
  belongs_to :user

  class << self
    def get_posts(params)
      if params[:user_id]
        Post.all.joins(:user).select("posts.*, users.email").where("posts.user_id != #{params[:user_id]}").limit(10).offset(params[:page].to_i * 10)
      else
        posts = Post.all.joins(:user).select("posts.*, users.email").limit(10).offset(params[:page].to_i * 10)
      end
    end
  end
end
