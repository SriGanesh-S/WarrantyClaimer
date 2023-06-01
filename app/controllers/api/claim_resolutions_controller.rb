class Api::ClaimResolutionsController< Api::ApiController
   before_action :set_claim_resolution, only: %i[ show update destroy ]
   # GET /claim_resolutions or /claim_resolutions.json
    def index
      claim_resolutions = current_user.userable.claim_resolutions
      if claim_resolutions
        render json: claim_resolutions, status: 200 #ok
      else
         render json: {message: "No Claim Resolutions Found"}, status:204 #no_content
      end
    end
  
    # GET /claim_resolutions/1 or /claim_resolutions/1.json
    def show

      if current_user.userable.claim_resolutions.include?(@claim_resolution)
        render json: @claim_resolution , status:200 #ok
     else
      render json:{message:"Forbidden Access to the profile"}, status:403 #forbidden
     end
    end
  
    
  
    # POST /claim_resolutions or /claim_resolutions.json
    def create
      warranty_claim=WarrantyClaim.find_by(id: params[:claim_resolution][:warranty_claim_id])
      if current_user.seller? && current_user.userable.warranty_claims.include?(warranty_claim)
        claim_resolution = ClaimResolution.new(claim_resolution_params)
        if (claim_resolution.save)
          render json:claim_resolution, status: 201#created
        else
          render json:{error: claim_resolution.errors.full_messages},  status:422 #unprocessable_entity
        end
      else
        render json:{message:"Forbidden Access to create the claim resolution"}, status:403 #forbidden
      end
      
    end
  
    # PATCH/PUT /claim_resolutions/1 or /claim_resolutions/1.json
    def update
      if current_user.seller? && current_user.userable.claim_resolutions.include?(@claim_resolution)
        if(@claim_resolution.update(claim_resolution_params))
           render json:@claim_resolution, status: 202#accepted
        else
           render json:{error: @claim_resolution.errors.full_messages}, status:422 #unprocessable_entity
         end
      else
        render json:{message:"Forbidden Access to update the Claim Resolution"}, status:403 #forbidden
      end
      
    end
  
    # DELETE /claim_resolutions/1 or /claim_resolutions/1.json
    def destroy
      if current_user.seller? && current_user.userable.claim_resolutions.include?( @claim_resolution)
        if @claim_resolution.destroy
          render json:{ message: "Claim Resolution Deleted successfully"},status:200 #ok
        else
          render json:{error: @claim_resolution.errors.full_messages}, status:422#unprocessable_entity
        end

      else
        render json:{error: "Fobidden Access to delete the claim resolution"}, status: 403
      end
    end
    
    def default_claim_resolution
      
      claim_resolution = ClaimResolution.find_by(id: params[:id])
      if claim_resolution
        if current_user.seller? && current_user.userable.claim_resolutions.include?(claim_resolution)
          claim_resolution.status="In Progress"
          claim_resolution.description="Our Team will Validate your claim"
          claim_resolution.save
          render json:claim_resolution, status:200
        
        else
          render json:{error: "Fobidden Access to reset the Claim Resolution"}, status: 403
         end
      else
        render json:{error: "No Claim Resolution found with Id #{params[:id]}"}, status: 404
      end
    end 

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_claim_resolution
        @claim_resolution = ClaimResolution.find_by(id: params[:id])
        if !@claim_resolution
          render json:{error: "No Claim Resolution found with Id #{params[:id]}"}, status: 404
          return 
        end
      end
  
      # Only allow a list of trusted parameters through.
      def claim_resolution_params
        params.fetch(:claim_resolution, {  }).permit( :warranty_claim_id , :status , :description )
      end



end
