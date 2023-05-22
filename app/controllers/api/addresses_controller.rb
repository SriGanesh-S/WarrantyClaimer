class Api::AddressesController < Api::ApiController
  before_action :set_address, only: %i[ show  update destroy ]

  # GET /addresses or /addresses.json
  def index
    @addresses = Address.all
    
    if @addresses
        render json: @addresses, status: 200 #ok
        else
         render json: {message: "No Addresses Found"}, status:204 #no_content
        end

  end

  # GET /addresses/1 or /addresses/1.json
  def show
    if @address
      render json: @address, status:200 #ok
    else
      render json:{message:" Address Not Found for Id #{params[:id]}"}, status:404 #not_found
    end
  end


  # POST /addresses or /addresses.json
  def create
    type=params[:address][:addressable_type]
    @user
    if type=="Seller"
      @user=Seller.find_by(id: params[:address][:addressable_id])
    elsif type=="Customer" 
      @user=Customer.find_by(id: params[:address][:addressable_id] )
    end

    if @user
      @address=Address.new(address_params)
         if(@address.save)
             render json:@address , status: 201#created
         else
             render json:{error: @address.errors.full_messages},status:422 #unprocessable_entity
         end
     else
         render json:{error: "No user Found with Given ID #{params[:address][:addresable_id]} and role #{params[:address][:addressable_type]}"}, status: 404#not_found
     end


  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
    if @address
      if(@address.update(address_params))
        render json:@address , status: 202#accepted
      else
        render json:{error: @address.errors.full_messages}, status:422 #unprocessable_entity
      end
    else
      render json:{error: "No Address Found with given Id#{params[:id]}"}, status:404 #not_found
    end
  end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    if @address
      type=@address.addressable_type
      if type=="Seller"
        @user=Seller.find_by(primary_address_id: params[:id])
      elsif type=="Customer" 
        @user=Customer.find_by(primary_address_id: params[:id])
      end
      
      if ! @user
         if(@address.destroy)
            render json:{ message: "Address Deleted successfully"},status:200 #ok
         else
            render json:{error: @address.errors.full_messages}, status:422#unprocessable_entity
         end
      else
        render json:{error: "Address is a Primary address please change primary address to delete it "}, status: 422#unprocessable_entity
      end 
    else
      render json:{error: "No Address Found with Given ID #{params[:id]}"}, status: 404#not_found
    end
  end

  # def primary_address
  #   @addresss_id = params[:id]
  #   current_user.userable.update(primary_address_id: @addresss_id)
  #   if current_user.customer?
  #     redirect_to cust_dashboard_path
  #   elsif current_user.seller?
  #     redirect_to seller_dashboard_path
  #   end
  # end

  # def change_primary_address
  #   @addresses = Address.where(addressable_id: current_user.userable.id)
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find_by(id: params[:id])
    end
   private
    # Only allow a list of trusted parameters through.
    def address_params
      params.fetch(:address, {}).permit(:door_no,:street,:district,:state,:pin_code,:phone,:addressable_id,:addressable_type)
    end

    
    
end
