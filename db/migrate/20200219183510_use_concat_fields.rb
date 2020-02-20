class UseConcatFields < ActiveRecord::Migration[6.0]
    def change        
      add_column :messages, :concat, :boolean
      add_column :messages, :concat_ref, :string
      add_column :messages, :concat_total, :string
      add_column :messages, :concat_part, :string
    end
  end