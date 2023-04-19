class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :category
      t.datetime :purcharse_date
      t.integer :seller_id
      t.timestamps
    end
  end
end
