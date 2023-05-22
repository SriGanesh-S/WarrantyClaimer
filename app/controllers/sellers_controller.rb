class SellersController < ApplicationController
   before_action :set_seller, only: %i[show edit update destroy]
   before_action :authenticate_user!
      #show all the seller in DB
    def index 
        @sellers=Seller.all
    end
  #used to instantiate a seller
    def new
        @seller=Seller.new
    end
  #used to insert the new record in DB
    def create
        @seller=Seller.new(seller_params)
        if(@seller.save)
            redirect_to sellers_path
        else
            render :new
        end

    end
  #used to display a particular record
    def show
    end
  #used to fetch the record to edit
    def edit
    end
  #saves the changes to DB
    def update
        if(@seller.update(seller_params))
            redirect_to seller_dashboard_path
        else
            render :edit 
        end
    end
  #deletes a record from DB
    def destroy
       
        if(@seller.destroy)
            redirect_to sellers_path
        else
            render :edit 
        end
    end

    
    def dashboard
        # @seller = Seller.find(current_user.userable.id)
       # @products = current_user.userable.products
        @warranty_claims = current_user.userable.warranty_claims

      

        p"==========="
        p @warranty_claims
       
       
      
      end
        
    
    

 private
    def set_seller
        @seller=Seller.find(params[:id])
    end
    def seller_params
        params.require( :seller).permit(:name, :email,:organisation_name,:designation,:description)
    end
end