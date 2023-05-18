ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :role, :userable_type, :userable_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :role, :userable_type, :userable_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column "User ID" , :id, sortable: :id do |i|
      link_to i.id , admin_user_path(i.id)
    end
    column "User Name" , :userable, sortable: :userable
    column :email
    column :role

    column :created_at
    column :updated_at
   end
  scope :all
  scope :customer
  scope :seller
  
  filter :id, label: "user ID"
  filter :email
  filter :role
  filter :created_at, label: "Created Date", as: :date_range
  filter :updated_at, label: "Last Updated Date", as: :date_range
end
