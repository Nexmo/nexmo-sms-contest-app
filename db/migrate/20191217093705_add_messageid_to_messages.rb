class AddMessageidToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :message_id, :string
  end
end
