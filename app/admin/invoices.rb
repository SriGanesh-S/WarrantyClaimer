ActiveAdmin.register Invoice do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :purchase_date, :product_id, :customer_id, :cust_email
  #
  # or
  #
  # permit_params do
  #   permitted = [:purchase_date, :product_id, :customer_id, :cust_email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column "Invoice ID" , :id, sortable: :id do |i|
      link_to i.id , admin_invoice_path(i.id)
    end
    column :customer
    column :cust_email
    column :product
    column  :purchase_date
  end
  scope :all
  scope :has_claimed
  scope :not_claimed  

  filter :customer
  filter :seller
  filter :cust_email , label: "Customer Email"
  filter :purchase_date, label: "Purchase Date"
  filter :product
end

