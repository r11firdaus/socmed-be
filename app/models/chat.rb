class Chat < ApplicationRecord
  self.primary_key = :unique_id
  # belongs_to :user, class_name: 'User'
  has_many :messages, class_name: 'Message', foreign_key: 'unique_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_1_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_2_id'
  validates :unique_id, presence: true, uniqueness: true

  class << self
    def all_chats(user_id)
      Chat.joins(:messages, :user)
      .where("user_1_id = #{user_id} OR user_2_id = #{user_id}")
      .select("chats.*, messages.content, messages.user_id, CASE WHEN messages.user_id != #{user_id} THEN users.email END as opponent")
      .order('messages.id DESC')
    end
  end
end
