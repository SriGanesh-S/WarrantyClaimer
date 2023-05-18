class AddInvoiceReferenceToWarrantyClaim < ActiveRecord::Migration[6.1]
  def change
    add_reference :warranty_claims, :invoice, foreign_key: true
  end
end
