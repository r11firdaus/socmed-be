class AddChatsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :chats, id: false do |t|
      t.references :user_1, null: false, foreign_key: { to_table: 'users' }
      t.references :user_2, null: false, foreign_key: { to_table: 'users' }
      t.string :content
      t.string :unique_id

      t.timestamps
    end
  end
end
