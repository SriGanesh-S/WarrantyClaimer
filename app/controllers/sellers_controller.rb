class SellersController < ApplicationController
   before_action :set_seller, only: %i[show edit update destroy]
   #before_action :authenticate_user!
   before_action :authorize_seller, only: %i[  edit destroy dashboard]
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
      unless current_user.userable == (@seller)
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end
  #used to fetch the record to edit
    def edit
      unless current_user.userable == (@seller)
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end
  #saves the changes to DB
    def update
        if(@seller.update(seller_params))
            render :show
        else
            render :edit 
        end
    end
  #deletes a record from DB
    def destroy
      unless current_user.userable == (@seller)
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
        if(@seller.destroy)
            redirect_to sellers_path
        else
            render :edit 
        end
    end

    
    def dashboard
        # @seller = Seller.find(current_user.userable.id)
       # @products = current_user.userable.products
       @customer_count = current_user.userable.customers.distinct.count
       @product_count = current_user.userable.products.distinct.count
       @invoice_count = current_user.userable.invoices.distinct.count
      #  p"==========="
      #  p @customer_count
        @warranty_claims = current_user.userable.warranty_claims.where.not(claim_resolution: ClaimResolution.where(status: ["Closed", "Rejected"]))


      

        # p @warranty_claims
       
       
      
      end
        
    
    

 private
    def set_seller
        @seller=Seller.find_by(id: params[:id])
    end
    def seller_params
        params.require( :seller).permit(:name, :email,:organisation_name,:designation,:description)
    end

    def authorize_seller
      unless (user_signed_in? && current_user.seller?)
        flash[:alert] = "You are not authorized to perform this action."
        redirect_to root_path
      end
    end

end