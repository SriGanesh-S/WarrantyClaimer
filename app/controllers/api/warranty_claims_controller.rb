class  Api::WarrantyClaimsController < Api::ApiController
    before_action :set_warranty_claim, only: %i[show  update destroy]
              #show all the warranty_claims in DB
            def index 
                @warranty_claims=WarrantyClaim.all
                if @warranty_claims
                    render json: @warranty_claims, status: 200 #ok
                    else
                     render json: {message: "No Warranty Claims Found"}, status:204 #no_content
                    end
            end
          
          #used to insert the new record in DB
            def create
                
                invoice=Invoice.find_by(id: params[:warranty_claim][:invoice_id])
               if invoice
                 @warranty_claim=WarrantyClaim.new(warranty_claim_params)
                    if(@warranty_claim.save)
                        set_claim_status 
                        render json:@warranty_claim , status: 201#created
                    else
                        render json:{error: @warranty_claim.errors.full_messages},status:422 #unprocessable_entity
                    end
                else
                    render json:{error: "No Invoice Found with Given ID #{params[:invoice_id]}"}, status: 404#not_found
                end
            end
          #used to display a particular record
            def show
                if @warranty_claim
                    render json: @warranty_claim , status:200 #ok
                  else
                    render json:{message:"warranty_claim Not Found for Id#{params[:id]}"}, status:404 #not_found
                  end
            end
         
          #saves the changes to DB
            def update
                if @warranty_claim    
                    if(@warranty_claim.update(update_warranty_claim_params))
                        render json:@warranty_claim , status: 202#accepted
                    else
                        render json:{error: @warranty_claim.errors.full_messages}, status:422 #unprocessable_entity
                    end
                 else
                   render json:{error: "No Warranty Claim Found with given Id#{params[:id]}"}, status:404 #not_found
                 end
            end
          #deletes a record from DB
            def destroy
               
                if @warranty_claim
                    if(@warranty_claim.destroy)
                      render json:{ message: "warranty_claim Deleted successfully"},status:200 #ok
                    else
                      render json:{error: @warranty_claim.errors.full_messages}, status:422#unprocessable_entity
                    end
       
                 else
                   render json:{error: "No Warranty Claim Found with Given ID #{params[:id]}"}, status: 404#not_found
                 end
            end
        
         private
            def set_warranty_claim
                @warranty_claim=WarrantyClaim.find(params[:id])
            end
            def warranty_claim_params
                params.require( :warranty_claim).permit( :invoice_id,:problem_description)
            end
            def update_warranty_claim_params
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
      
           