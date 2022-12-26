class Post < ApplicationRecord
  belongs_to :user

  class << self
    def get_posts(params)
      if params[:user_id]
        Post.all.joins(:user).select("posts.*, users.email").where("posts.user_id != #{params[:user_id]}").limit(5).offset(params[:page].to_i * 5)
      else
        posts = Post.all.joins(:user).select("posts.*, users.email").limit(5).offset(params[:page].to_i * 5)
      end
    end
  end
end
