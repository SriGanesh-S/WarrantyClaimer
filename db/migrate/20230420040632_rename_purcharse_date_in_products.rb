class RenamePurcharseDateInProducts < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :purcharse_date, :sold_date
  end
end
