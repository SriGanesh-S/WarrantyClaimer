class WarrantyClaimsController < ApplicationController
    before_action :set_warranty_claim, only: %i[show edit update destroy]
              #show all the warranty_claims in DB
            def index 
                @warranty_claims=WarrantyClaim.all
            end
          #used to instantiate a warranty_claim
            def new
                @warranty_claim=WarrantyClaim.new
            end
          #used to insert the new record in DB
            def create
                @warranty_claim=WarrantyClaim.new(warranty_claim_params)
                @warranty_claim.customer_id=1
                if(@warranty_claim.save)
                    redirect_to warranty_claims_path
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

                if(@warranty_claim.update(product_params))
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
                params.require( :warranty_claim).permit(:product_id, :problem_description)
            end
        
   end
      
           