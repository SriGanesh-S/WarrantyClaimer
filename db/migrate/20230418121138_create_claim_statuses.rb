class CreateClaimStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :claim_statuses do |t|
      t.references :warranty_claim, null: false, foreign_key: true
      t.string :status
      t.text :description

      t.timestamps
    end
  end
end
