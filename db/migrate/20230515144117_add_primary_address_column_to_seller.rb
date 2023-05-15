class AddPrimaryAddressColumnToSeller < ActiveRecord::Migration[6.1]
  def change
    add_column :sellers, :primary_address, :integer
    add_reference :sellers, :primary_address, foreign_key: { to_table: :addresses }
  end
end
