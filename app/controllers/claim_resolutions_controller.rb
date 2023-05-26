class ClaimResolutionsController < ApplicationController
    before_action :set_claim_resolution, only: %i[ show edit update destroy ]
    before_action :authenticate_user! 
    before_action :authorize_seller, only: %i[ new edit destroy ]
   # GET /claim_resolutions or /claim_resolutions.json
    def index

      @claim_resolutions = current_user.userable.claim_resolutions
    end
  
    # GET /claim_resolutions/1 or /claim_resolutions/1.json
    def show
      unless current_user.userable.claim_resolutions.include?(@claim_resolution)
        
        redirect_to root_path
        flash[:notice] = "You are not authorized to perform this action."
        return
      end
    end
  
    # GET /claim_resolutions/new
    def new
      @claim_resolution = ClaimResolution.new
    end
  
    # GET /claim_resolutions/1/edit
    def edit
      unless current_user.userable.claim_resolutions.include?(@claim_resolution)
        flash[:notice] = "You are not authorized to perform this action."
        redirect_to root_path
        return
      end
    end
  
    # POST /claim_resolutions or /claim_resolutions.json
    def create
       warranty_claim=WarrantyClaim.find_by(id: params[:warranty_claim_id])
      unless current_user.userable.warranty_claims.include?(warranty_claim)
        flash[:notice] = "You are not authorized to perform this action."
        redirect_to root_path
        return
      end
      @claim_resolution = ClaimResolution.new(claim_resolution_params)
  
      respond_to do |format|
        if @claim_resolution.save
          format.html { redirect_to claim_resolution_url(@claim_resolution), notice: "Claim status was successfully created." }
          format.json { render :show, status: :created, location: claim_resolution }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @claim_resolution.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /claim_resolutions/1 or /claim_resolutions/1.json
    def update
     
      respond_to do |format|
        if @claim_resolution.update(claim_resolution_params)
          format.html { redirect_to claim_resolution_url(@claim_resolution), notice: "Claim status was successfully updated." }
          format.json { render :show, status: :ok, location: @claim_resolution }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @claim_resolution.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /claim_resolutions/1 or /claim_resolutions/1.json
    def destroy
      @claim_resolution.destroy
  
      respond_to do |format|
        format.html { redirect_to claim_resolutions_url, notice: "Claim status was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_claim_resolution
        @claim_resolution = ClaimResolution.find_by(id:params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def claim_resolution_params
        params.fetch(:claim_resolution, {  }).permit( :warranty_claim_id , :status , :description )
      end

      def authorize_seller
        unless  (user_signed_in? && current_user.seller?)
          flash[:notice] = "You are not authorized to perform this action."
          redirect_to root_path
          return
        end
      end


end
