class AddEmailToSeller < ActiveRecord::Migration[6.1]
  def change

    add_column :sellers, :email, :string
  end
end
