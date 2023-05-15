class AddColumnsToCustomer < ActiveRecord::Migration[6.1]
  def change
    add_column :customers ,:age ,:integer
    add_column :customers ,:gender ,:string
    add_column :customers, :phone_no ,:bigint
  
  end
end
