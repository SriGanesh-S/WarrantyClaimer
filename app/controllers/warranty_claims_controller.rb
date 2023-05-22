class WarrantyClaimsController < ApplicationController
    before_action :set_warranty_claim, only: %i[show edit update destroy]
              #show all the warranty_claims in DB
            def index 
                @warranty_claims=WarrantyClaim.all
            end
          #used to instantiate a warranty_claim
            def new
                @warranty_claim=WarrantyClaim.new
                @id=params[:id]
            end
          #used to insert the new record in DB
            def create
                @warranty_claim=WarrantyClaim.new(warranty_claim_params)
                @warranty_claim.invoice_id=params[:warranty_claim][:id]
                p "============="
                p @warranty_claim
                if(@warranty_claim.save)
                    set_claim_status 
                    redirect_to primary_address_path
                else
                    render :new
                end
        
            end
          #used to display a particular record
            def show
            end
          #used to fetch the record to edit
            def edit
            end
          #saves the changes to DB
            def update
                 @warranty_claim.customer_id 

                if(@warranty_claim.update(warranty_claim_params))
                    redirect_to warranty_claims_path
                else
                    render :edit 
                end
            end
          #deletes a record from DB
            def destroy
               
                if(@warranty_claim.destroy)
                    redirect_to warranty_claims_path
                else
                    render :edit 
                end
            end
        
         private
            def set_warranty_claim
                @warranty_claim=WarrantyClaim.find(params[:id])
            end
            def warranty_claim_params
                params.require( :warranty_claim).permit( :problem_description)
            end
            def set_claim_status
                @claim_status=ClaimResolution.new
                @claim_status.warranty_claim_id=@warranty_claim.id
                @claim_status.status="In Progress"
                @claim_status.description="Our Team will Validate your claim"
                @claim_status.save

            end
        
   end
      
           