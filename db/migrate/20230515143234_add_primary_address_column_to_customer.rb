class AddPrimaryAddressColumnToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :primary_address, :integer
    add_reference :customers, :primary_address, foreign_key: { to_table: :addresses }
  end
end
