class ClaimStatusesController < ApplicationController
  before_action :set_claim_status, only: %i[ show edit update destroy ]

  # GET /claim_statuses or /claim_statuses.json
  def index
    @claim_statuses = ClaimStatus.all
  end

  # GET /claim_statuses/1 or /claim_statuses/1.json
  def show
  end

  # GET /claim_statuses/new
  def new
    @claim_status = ClaimStatus.new
  end

  # GET /claim_statuses/1/edit
  def edit
  end

  # POST /claim_statuses or /claim_statuses.json
  def create
    @claim_status = ClaimStatus.new(claim_status_params)

    respond_to do |format|
      if @claim_status.save
        format.html { redirect_to claim_status_url(@claim_status), notice: "Claim status was successfully created." }
        format.json { render :show, status: :created, location: @claim_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @claim_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /claim_statuses/1 or /claim_statuses/1.json
  def update
    respond_to do |format|
      if @claim_status.update(claim_status_params)
        format.html { redirect_to claim_status_url(@claim_status), notice: "Claim status was successfully updated." }
        format.json { render :show, status: :ok, location: @claim_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @claim_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /claim_statuses/1 or /claim_statuses/1.json
  def destroy
    @claim_status.destroy

    respond_to do |format|
      format.html { redirect_to claim_statuses_url, notice: "Claim status was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim_status
      @claim_status = ClaimStatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def claim_status_params
      params.fetch(:claim_status, {  }).permit( :warranty_claim_id , :status , :description )
    end
end
