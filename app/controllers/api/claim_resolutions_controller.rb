class ClaimResolutionsContr< Api::ApiController
    before_action :set_claim_resolution, only: %i[ show edit update destroy ]
   # GET /claim_resolutions or /claim_resolutions.json
    def index
      @claim_resolutions = ClaimResolution.all
    end
  
    # GET /claim_resolutions/1 or /claim_resolutions/1.json
    def show
    end
  
    # GET /claim_resolutions/new
    def new
      @claim_resolution = ClaimResolution.new
    end
  
    # GET /claim_resolutions/1/edit
    def edit
    end
  
    # POST /claim_resolutions or /claim_resolutions.json
    def create
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
        @claim_resolution = ClaimResolution.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def claim_resolution_params
        params.fetch(:claim_resolution, {  }).permit( :warranty_claim_id , :status , :description )
      end



end
