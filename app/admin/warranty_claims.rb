ActiveAdmin.register WarrantyClaim do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :problem_description, :invoice_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:problem_description, :invoice_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    column "Claim ID" , :id, sortable: :id do |i|
      link_to i.id , admin_product_path(i.id)
    end
    column :problem_description
    column "Invoice" ,:invoice_id do |i|
      link_to i.invoice_id , admin_invoice_path(i.invoice_id)
    end
    
    column "Resolution" ,:claim_resolution_id do |i|
      link_to i.claim_resolution.id , admin_claim_resolution_path(i.claim_resolution.id)
    end
    column  :created_at
    column :updated_at
    
  end

  scope :all
  scope :open_claims
  scope :closed_claims

  filter :invoice_id
  filter :problem_description
  filter :created_at
  filter :updated_at
end
