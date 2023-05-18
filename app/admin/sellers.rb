ActiveAdmin.register Seller do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :organisation_name, :designation, :phone_no, :primary_address, :primary_address_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :organisation_name, :designation, :phone_no, :primary_address, :primary_address_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column "Seller ID" , :id, sortable: :id do |i|
      link_to i.id , admin_seller_path(i.id)
    end
    column "Name" , :name, sortable: :name
    column :email
    column  :organisation_name
    column :designation
  end


   scope :all
   scope :has_sold
   scope :not_sold
  


  filter :id, label: "Seller ID"
  filter :products ,label: "Products Sold"
  filter :name
  filter :email
  filter :organisation_name
  filter :designation

end
