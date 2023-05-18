ActiveAdmin.register Product do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :category, :seller_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :category, :seller_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column "Product ID" , :id, sortable: :id do |i|
      link_to i.id , admin_product_path(i.id)
    end
    column "Seller" ,:seller, sortable: :seller
    column "Name" , :name, sortable: :name
    column :category
    
  end
  scope :all
  scope :sold
  scope :not_sold


  filter :id, label: "Product ID"
  filter :name
  filter :seller
  filter :category
  filter :created_at, label: "Created Date", as: :date_range
  filter :updated_at, label: "Last Updated Date", as: :date_range
end
