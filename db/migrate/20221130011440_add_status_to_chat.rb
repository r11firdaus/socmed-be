class AddStatusToChat < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :status, :integer
  end
end
