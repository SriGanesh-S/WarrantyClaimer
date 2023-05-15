class AddColumnsToSeller < ActiveRecord::Migration[6.1]
  def change
   
    add_column :sellers ,:organisation_name, :string
    add_column :sellers ,:designation, :string
    add_column :sellers, :phone_no, :bigint
  end
end
