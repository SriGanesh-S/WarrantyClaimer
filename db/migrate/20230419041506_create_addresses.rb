class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :door_no
      t.string :street
      t.string :district
      t.string :state
      t.integer :pin_code
      t.bigint :phone

      t.timestamps
    end
  end
end
