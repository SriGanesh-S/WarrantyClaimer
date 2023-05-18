ActiveAdmin.register ClaimResolution do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :warranty_claim_id, :status, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:warranty_claim_id, :status, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

   index do
    column "ClaimResolutionID" , :id, sortable: :id do |i|
      link_to i.id , admin_claim_resolution_path(i.id)
    end
    column  "WarrantyClaimID" ,:warranty_claim_id do|i|
       
      link_to i.warranty_claim_id ,admin_warranty_claim_path(i.warranty_claim)
    end
    column :status
    column :description
    
    column "Last Updated", :updated_at,sortable: :updated_at do |claim_resolution|
      claim_resolution.updated_at.strftime("%d-%m-%Y")
    end
  
  

   end

  scope :all
  scope :resolved
  scope :pending
  
  filter :id, label: "Resolution ID"
  filter :status , as: :select , collection: [['Accepted','Accepted'] , ['Rejected','Rejected'],['In Progress','In progress'],['Shipped','Shipped'],['Closed','Closed']]
  filter :updated_at, label: "Last Updated Date", as: :date_range

  
end
