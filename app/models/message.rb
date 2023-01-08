class Message < ApplicationRecord
  # belongs_to :user
  belongs_to :user, class_name: 'User', foreign_key: 'receiver_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  class << self
    def direct_chats(user_1_id, user_2_id)
      Message.where("unique_id = '#{user_1_id}+#{user_2_id}' OR unique_id = '#{user_2_id}+#{user_1_id}'")
    end
    
    def all_chats(user_id)
      Message.joins(:user)
      .select("messages.*, (CASE
              WHEN messages.user_id=#{user_id} THEN (SELECT email FROM users WHERE messages.receiver_id=users.id)
              ELSE (SELECT email FROM users WHERE messages.user_id=users.id)
              END) as opponent")
      .where(user_id: user_id)
      .or(Message.where(receiver_id: user_id))
      .order('messages.id DESC')
    end

    def direct_message(params)
      query = "with inserted_messages as (
              insert into messages (unique_id, user_id, receiver_id, content, created_at, updated_at) 
              values ('#{params[:unique_id]}', #{params[:user_id]}, #{params[:receiver_id]}, '#{params[:content]}', '#{Time.now}', '#{Time.now}') returning *) 
              select inserted_messages.*,
              (CASE
              WHEN inserted_messages.user_id=#{params[:user_id]} THEN (SELECT users.email from users WHERE inserted_messages.receiver_id=users.id)
              ELSE (SELECT users.email FROM users WHERE inserted_messages.user_id=users.id)
              END) as opponent
              from inserted_messages
              left join users on inserted_messages.user_id = users.id;"

      ActiveRecord::Base.connection.execute(query)
    end
  end
end


# ,
#               (CASE
#               WHEN inserted_messages.user_id=#{params[:user_id]} THEN (SELECT users.email from users WHERE inserted_messages.receiver_id=users.id)
#               ELSE (SELECT users.email FROM users WHERE inserted_messages.user_id=users.id)
#               END) as opponent