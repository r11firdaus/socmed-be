class Message < ApplicationRecord
  belongs_to :user
  validates :receiver_id, presence: :true

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
  end
end
