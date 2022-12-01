class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat, foreign_key: 'unique_id'

  class << self
    def direct_chats(user_1_id, user_2_id)
      Message.joins(:chat)
      .where("chats.user_1_id = #{user_1_id} AND chats.user_2_id = #{user_2_id} OR chats.user_1_id = #{user_2_id} AND chats.user_2_id = #{user_1_id}")
    end
    
    def send_message(user_1_id, user_2_id, unique_id, content)
      
    end    
  end
end
