class CreateCustomersSellersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_join_table :customers, :sellers
  end
end
