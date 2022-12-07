class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  class << self
    def save_comment(params)
      query = "with inserted_comment as (
              insert into comments (post_id, user_id, content, created_at, updated_at) 
              values (#{params[:post_id]}, #{params[:user_id]}, '#{params[:content]}', '#{Time.now}', '#{Time.now}') returning *) 
              select inserted_comment.post_id, inserted_comment.user_id, inserted_comment.content, inserted_comment.created_at, inserted_comment.updated_at, users.email from inserted_comment 
              left join users on inserted_comment.user_id = users.id;"

      ActiveRecord::Base.connection.execute(query)
    end    
  end
end
