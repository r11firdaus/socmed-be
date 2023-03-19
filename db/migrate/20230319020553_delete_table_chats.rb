class DeleteTableChats < ActiveRecord::Migration[6.1]
  def up
    drop_table :chats
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
