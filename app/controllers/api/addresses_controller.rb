class Api::AddressesController < Api::ApiController
  before_action :set_address, only: %i[ show  update destroy ]

  # GET /addresses or /addresses.json
  def index
    addresses = current_user.userable.addresses
    
    if addresses
        render json: addresses, status: 200 #ok
        else
         render json: {message: "No Addresses Found"}, status:204 #no_content
        end

  end

  # GET /addresses/1 or /addresses/1.json
  def show
    if @address
     if current_user.userable.addresses.include? @address
       render json: @address, status:200 #ok
      else
       render json:{message:"Forbidden Access to the Address"}, status:403 #forbidden
     end
    else
      render json:{message:"Address Not Found for Given Id"}, status:404 
    end
  end


  # POST /addresses or /addresses.json
  def create
      address=Address.new(address_params)
      address.addressable_id=current_user.userable_id
      address.addressable_type=current_user.userable_type
         if(address.save)
             render json:address , status: 201#created
         else
             render json:{error: address.errors.full_messages},status:422 #unprocessable_entity
         end
    


  end

  # PATCH/PUT /addresses/1 or /addresses/1.json
  def update
   if @address
    if current_user.userable.addresses.include?(@address)
      if(@address.update(address_params))
        render json:@address , status: 202#accepted
      else
        render json:{error: @address.errors.full_messages}, status:422 #unprocessable_entity
      end
    else
      render json:{message:"Forbidden Access to update the address"}, status:403 #forbidden
    end
   else
    render json:{message:"Address Not Found for Given Id"}, status:404 
   end 
 end

  # DELETE /addresses/1 or /addresses/1.json
  def destroy
    if @address
    if current_user.userable.addresses.include?(@address)
      primary_address=false
      if current_user.userable.primary_address_id == params[:id].to_i
        primary_address=true
      end
     # p "================================"
      #p primary_address
      if ! primary_address
         if(@address.destroy)
            render json:{ message: "Address Deleted successfully"},status:200 #ok
         else
            render json:{error: @address.errors.full_messages}, status:422#unprocessable_entity
         end
      else
        render json:{error: "Address is a Primary address please change primary address to delete it "}, status: 422#unprocessable_entity
      end 
    else
      render json:{error: "Fobidden Access to delete the Address"}, status: 403

    end
    else
    render json:{message:"Address Not Found for Given Id"}, status:404 
   end
  end

  def primary_address
    address =Address.find_by(id: params[:id])
    if address
      if current_user.userable.addresses.include?(address )
        if current_user.userable.update(primary_address_id: address.id)
         render json:{ message: " Primary Address Changed successfully"},status:200 #ok
        else
          render json:{error: address.errors.full_messages}, status:422 #unprocessable_entity
       end
      else
        render json:{error: "Fobidden Access to the specified Address"}, status: 403
      end
    else
      render json:{message:"Address Not Found for Given Id"}, status:404 
    end
    
  end

  # def change_primary_address
  #   addresses = Address.where(addressable_id: current_user.userable.id)
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find_by(id: params[:id])
    end
   private
    # Only allow a list of trusted parameters through.
    def address_params
      params.fetch(:address, {}).permit(:door_no,:street,:district,:state,:pin_code,:phone)
    end

    
    
end
