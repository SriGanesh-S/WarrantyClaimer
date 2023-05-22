class AddressesController < ApplicationController
  before_action :set_address, only: %i[ show edit update destroy ]

  # GET /addresses or /addresses.json
  def index
    @addresses = Address.all
  end

  # GET /addresses/1 or /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses or /addresses.json
  def create
    @address = Address.new(address_params)

    respond_to do |format|
      @address.addressable_id=current_user.userable_id
      @address.addressable_type=current_user.role
      if @address.save
        format.html { redirect_to address_url(@address), notice: "Address was successfully created." }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    respond_to do |format|
      @address.addressable_id=current_user.userable_id
      @address.addressable_type=current_user.role
      if @address.update(address_params)
        format.html { redirect_to address_url(@address), notice: "Address was successfully updated." }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    @address.destroy

    respond_to do |format|
      format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def primary_address
    @addresss_id = params[:id]
    current_user.userable.update(primary_address_id: @addresss_id)
    if current_user.customer?
      redirect_to cust_dashboard_path
    elsif current_user.seller?
      redirect_to seller_dashboard_path
    end
  end

  def change_primary_address
    @addresses = Address.where(addressable_id: current_user.userable.id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end
   private
    # Only allow a list of trusted parameters through.
    def address_params
      params.fetch(:address, {}).permit(:door_no,:street,:district,:state,:pin_code,:phone,:addressable_id,:addressable_type)
    end

    
    
end
