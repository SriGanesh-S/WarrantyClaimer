class  Api::WarrantyClaimsController < Api::ApiController
    before_action :set_warranty_claim, only: %i[show  update destroy]
              #show all the warranty_claims in DB
            def index 
                warranty_claims=current_user.userable.warranty_claims
                if warranty_claims
                    render json: warranty_claims, status: 200 #ok
                    else
                     render json: {message: "No Warranty Claims Found"}, status:204 #no_content
                    end
            end
          
          #used to insert the new record in DB
            def create
                
                invoice=Invoice.find_by(id: params[:warranty_claim][:invoice_id])
            
                if current_user.userable.invoices.include?(invoice)&&current_user.customer?
                 @warranty_claim=WarrantyClaim.new(warranty_claim_params)
                    
                    if(@warranty_claim.save)
                        set_claim_status 
                        render json:@warranty_claim , status: 201#created
                    else
                        render json:{error: @warranty_claim.errors.full_messages},status:422 #unprocessable_entity
                    end
                else
                    render json:{error: "Forbidden Access to create claim ,You can create claim only for products you purchased"}, status: 403#forbidden
                end
            end
          #used to display a particular record
            def show

                if current_user.userable.warranty_claims.include?(@warranty_claim)
                    render json: @warranty_claim , status:200 #ok
                  else
                    render json:{error: "Forbidden Access to Warranty Claim"}, status: 403#forbidden
                  end
            end
         
          #saves the changes to DB
            def update
              if current_user.userable.warranty_claims.include?(@warranty_claim)&&current_user.customer?   
                    if(@warranty_claim.update(update_warranty_claim_params))
                        render json:@warranty_claim , status: 202#accepted
                    else
                        render json:{error: @warranty_claim.errors.full_messages}, status:422 #unprocessable_entity
                    end
                 else
                  render json:{error: "Forbidden Access to  Modify Claim"}, status: 403#forbidden
                 end

            end
          #deletes a record from DB
            def destroy
              if current_user.userable.warranty_claims.include?(@warranty_claim) && current_user.customer? 
                if @warranty_claim.claim_resolution==nil || ["In Progress","Accepted"].include?(@warranty_claim.claim_resolution.status)
                    if(@warranty_claim.destroy)
                      render json:{ message: "warranty_claim Deleted successfully"},status:200 #ok
                    else
                      render json:{error: @warranty_claim.errors.full_messages}, status:422#unprocessable_entity
                    end
       
                 else
                   render json:{error: "You Cannot Delete the Claim Once it's Shipped"}, status: 403#forbidden
                 end
              else
                  render json:{error: "Forbidden Access to  Modify Claim"}, status: 403#forbidden
              end
            end
        
         private
            def set_warranty_claim
                @warranty_claim=WarrantyClaim.find_by(id: params[:id])
                if !@warranty_claim
                  render  json:{error: "No Warranty Claim found with given Id#{params[:id]}"} , status:404
                  return
                end

            end
            def warranty_claim_params
                params.require( :warranty_claim).permit( :invoice_id,:problem_description)
            end
            def update_warranty_claim_params
                params.require( :warranty_claim).permit( :problem_description)
            end
            def set_claim_status
                claim_status=ClaimResolution.new
                claim_status.warranty_claim_id=@warranty_claim.id
                claim_status.status="In Progress"
            
                claim_status.save

            end
        
   end
      
           