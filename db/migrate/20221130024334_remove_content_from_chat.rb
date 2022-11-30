class RemoveContentFromChat < ActiveRecord::Migration[6.1]
  def change
    remove_column :chats, :content, :string
  end
end
