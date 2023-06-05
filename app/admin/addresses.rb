ActiveAdmin.register Address do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :door_no, :street, :district, :state, :pin_code, :phone, :addressable_type, :addressable_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:door_no, :street, :district, :state, :pin_code, :phone, :addressable_type, :addressable_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column "Address ID" , :id, sortable: :id do |i|
      link_to i.id , admin_address_path(i.id)
    end
    column "Name" , :addressable
    column "Role" , :addressable_type
    column :door_no
    column :street
    column :district
    column :state
    column :pin_code
    column :phone
   end
  scope :all
  scope :customers
  scope :sellers

  
  filter :door_no
  filter :street
  filter :district
  filter :state
  filter :pin_code
  filter :phone
  
end
