class WarrantyClaimsController < ApplicationController
    before_action :set_warranty_claim, only: %i[show edit update destroy]
              #show all the warranty_claims in DB
              before_action :authenticate_user!
              before_action :authorize_customer, only: %i[ new edit destroy ]
            def index 
                @warranty_claims=current_user.userable.warranty_claims
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
                invoice=Invoice.find_by(id: @warranty_claim.invoice_id)

                unless current_user.userable.invoices.include?(invoice)
                    flash[:notice] = "You are not authorized to perform this action."
                    redirect_to root_path
                end

                if(@warranty_claim.save)
                    set_claim_status 
                    render :index
                else
                    render :new
                end
        
            end
          #used to display a particular record
            def show
                unless current_user.userable.warranty_claims.include?(@warranty_claim)
                    flash[:notice] = "You are not authorized to perform this action."
                    redirect_to root_path
                    return
                end
            end
          #used to fetch the record to edit
            def edit
                unless current_user.userable.warranty_claims.include?(@warranty_claim)
                    flash[:notice] = "You are not authorized to perform this action."
                    redirect_to root_path
                    return
                end
            end
          #saves the changes to DB
            def update
                

                if(@warranty_claim.update(warranty_claim_params))
                    render :show
                else
                    render :edit 
                end
            end
          #deletes a record from DB
            def destroy
                unless current_user.userable.warranty_claims.include?(@warranty_claim)
                    flash[:notice] = "You are not authorized to perform this action."
                    redirect_to root_path
                end
                if  ["In Progress","Accepted"].include?(@warranty_claim.claim_resolution.status) 
                    if(@warranty_claim.destroy)
                        redirect_to warranty_claims_path
                     else
                        render :edit 
                     end
                else
                    flash[:notice] = "You cannot Delete claim once It's Shipped or Closed."
                    redirect_to cust_dashboard_path
                end
            end
        
         private
            def set_warranty_claim
                @warranty_claim=WarrantyClaim.find_by(id:  params[:id])
            end
            def warranty_claim_params
                params.require( :warranty_claim).permit( :problem_description)
            end
            def set_claim_status
                @claim_status=ClaimResolution.new
                @claim_status.warranty_claim_id=@warranty_claim.id
                @claim_status.status="In Progress"
                @claim_status.save

            end

            def authorize_customer
                unless (user_signed_in? && current_user.customer?)
                  flash[:notice] = "You are not authorized to perform this action."
                  redirect_to root_path
                end
              end
        
   end
      
           