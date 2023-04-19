class CreateWarrantyClaims < ActiveRecord::Migration[6.1]
  def change
    create_table :warranty_claims do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.text :problem_description

      t.timestamps
    end
  end
end
