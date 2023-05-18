class RemovePrimaryAddressColumnFromSellerAndCustomer < ActiveRecord::Migration[6.1]
  def change
    remove_column :sellers, :primary_address
    remove_column :customers, :primary_address

  end
end
