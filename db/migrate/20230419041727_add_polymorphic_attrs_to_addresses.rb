class AddPolymorphicAttrsToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :addressable_type, :string
    add_column :addresses, :addressable_id, :integer
    
  end
end
