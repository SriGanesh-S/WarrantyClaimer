class RemoveCustomerReferenceAndSellerReferenceFromWarrantyClaim < ActiveRecord::Migration[6.1]
  def change
    remove_reference :warranty_claims, :product, foreign_key: true
    remove_reference :warranty_claims, :customer, foreign_key: true
  end
end
