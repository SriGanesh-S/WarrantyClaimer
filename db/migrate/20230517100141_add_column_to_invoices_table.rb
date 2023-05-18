class AddColumnToInvoicesTable < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices , :cust_email, :string

  end
end
