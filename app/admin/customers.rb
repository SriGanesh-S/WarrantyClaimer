ActiveAdmin.register Customer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :age, :gender, :phone_no, :primary_address, :primary_address_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :age, :gender, :phone_no, :primary_address, :primary_address_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column "Customer ID" , :id, sortable: :id do |i|
      link_to i.id , admin_customer_path(i.id)
    end
    column "Name" , :name, sortable: :name
    column :email
    column  :age
    column :gender
    column :phone_no
    column "Primary Address" , :id, sortable: :id do |i|
      link_to i.primary_address_id , admin_address_path(i.primary_address_id)
    end
  end

  scope :all
  scope :has_purchased
  scope :not_purchased 
  

  filter :id, label: "Customer ID"
  filter :name
  filter :email
  filter :age
  filter :gender
  filter :phone_no

end
