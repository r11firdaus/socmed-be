class AddReceiverIdToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :receiver_id, :integer
  end
end
