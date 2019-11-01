class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :name
      t.string :phone_number
      t.string :twitter, :default => 'not provided'
      t.string :email
      t.string :message
      t.timestamps
    end
  end
end
