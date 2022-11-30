class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.references :user_1, null: false, foreign_key: { to_table: 'users' }
      t.references :user_2, null: false, foreign_key: { to_table: 'users' }
      t.string :content

      t.timestamps
    end
  end
end
