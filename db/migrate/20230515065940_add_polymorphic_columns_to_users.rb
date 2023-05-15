class AddPolymorphicColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :userable_type, :string
    add_column :users, :userable_id, :integer
  end
end
