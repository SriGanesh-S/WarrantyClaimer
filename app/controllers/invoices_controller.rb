class InvoicesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_seller, only: %i[ new generate ] 
    
   def new
    @invoice=Invoice.new
    @product = Product.find_by(id: params[:id])
    # p "==============="
    # p  @product

   end
   def index 
    @invoices =current_user.userable.invoices

   end


   def generate
    @invoice = Invoice.new(create_params)
    @customer =Customer.find_by(email: params[:invoice][:cust_email])
    @product = Product.find_by(id: params[:invoice][:id])
    unless (@product!=nil && current_user.userable.products.include?(@product))
      # p "\n \n product is nil\n \n \n "
      flash[:alert] = "You are not authorized "
      render :new
      return
    end
    if @customer
    
    # p "========="
    # p params[:invoice][:cust_email]
    # p "==========================="
    # p @customer
    # p @invoice
    # p @product
    # p "========="

    
    @invoice.customer_id=@customer.id
    @invoice.product_id=@product.id
    if @invoice.save
      @customer.sellers << current_user.userable
         redirect_to seller_dashboard_path, notice: "Invoice generated successfully!" 
    else
        render :new , alert: "Failed to generate invoice."
    end
  else
    flash.now[:alert]="Enter valid Customer mail " 
  end 
   end


   private
   def create_params
        params.require( :invoice).permit(:cust_email , :purchase_date)
   end

   def authorize_seller
    unless (user_signed_in? && current_user.seller?)
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
  
end
      
