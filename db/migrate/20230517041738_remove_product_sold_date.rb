class RemoveProductSoldDate < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :sold_date
  end
end
