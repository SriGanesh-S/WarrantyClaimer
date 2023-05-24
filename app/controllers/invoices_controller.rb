class InvoicesController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_seller, only: %i[ new generate ] 
    
   def new
    @invoice=Invoice.new
    @product = Product.find_by(id: params[:id])
    p "==============="
    p  @product

   end



   def generate
    @invoice = Invoice.new(create_params)
    @customer =Customer.find_by(email: params[:invoice][:cust_email])
    if @customer
    @product = Product.find_by(id: params[:invoice][:id])
    unless current_user.userable.products.include?(@product)
      flash[:notice] = "You are not authorized to perform this action."
      redirect_to root_path
    end
    p "========="
    p params[:invoice][:cust_email]
    p "==========================="
    p @customer
    p @invoice
    p @product
    p "========="
    @invoice.customer_id=@customer.id
    @invoice.product_id=@product.id
    if @invoice.save
        redirect_to seller_dashboard_path, notice: "Invoice generated successfully!" 
    else
        redirect_to new , alert: "Failed to generate invoice."
    end
  else
    flash[:notice]="Enter valid Customer mail " 
  end 
   end


   private
   def create_params
        params.require( :invoice).permit(:cust_email , :purchase_date)
   end

   def authorize_seller
    unless current_user.seller?
      flash[:notice] = "You are not authorized to perform this action."
      redirect_to root_path
    end
  end
  
end
      
