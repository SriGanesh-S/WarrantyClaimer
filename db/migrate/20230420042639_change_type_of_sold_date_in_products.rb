class ChangeTypeOfSoldDateInProducts < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        change_column :products, :sold_date, :date 
      end
      dir.down do
        change_column :products, :sold_date, :datetime
      end 
    end
  end
end
