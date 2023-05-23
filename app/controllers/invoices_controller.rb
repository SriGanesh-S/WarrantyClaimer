class InvoicesController < ApplicationController
    before_action :authenticate_user!
   def new
    @invoice=Invoice.new
    @product = Product.find(params[:id])
    p "==============="
    p  @product

   end



   def generate
    @invoice = Invoice.new(create_params)
    @customer =Customer.find_by(email: params[:invoice][:cust_email])
    if @customer
    @product = Product.find(params[:invoice][:id])
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
end
      
