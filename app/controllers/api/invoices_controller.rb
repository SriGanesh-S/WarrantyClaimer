class Api::InvoicesController < Api::ApiController
   before_action :set_invoice, only: %i[show  update destroy]
    def index 
    invoices=Invoice.all
                if invoices
                    render json: invoices, status: 200 #ok
                else
                     render json: {message: "No Invoices Found"}, status:204 #no_content
                end
     end
  def create
     product=Product.find_by(id: params[:invoice][:product_id])
     customer =Customer.find_by(email: params[:invoice][:cust_email])
     if current_user.seller? && current_user.userable.products.include?(product)
        if customer
            invoice=Invoice.new(create_params)
            invoice.customer_id=customer.id   
            if (invoice.save)
                render json:invoice, status: 201#created
            else
                render json:{error: invoice.errors.full_messages},  status:422 #unprocessable_entity
            end
        else
            render json:{error: "No Customer Found with Given Email #{params[:invoice][:cust_email]}"}, status: 404#not_found
        end
     else
        render json:{message:"Forbidden Access to generate invoice for this product"}, status:403 #forbidden
     end
               
  end  
  
 def show
     if current_user.userable.invoices.include?(@invoice)
        render json: @invoice , status:200 #ok
     else
        render json:{message:"Forbidden Access to view the invoice"}, status:403 #forbidden
     end  
 end
              
def update
    if current_user.seller?  && current_user.userable.invoices.include?(@invoice)
        if(@invoice.update(create_params))
           render json:@invoice , status: 202#accepted
        else
           render json:{error: @invoice.errors.full_messages}, status:422 #unprocessable_entity
         end
     else
        render json:{message:"Forbidden Access to update the Invoice"}, status:403 #forbidden
     end
end
 def destroy
               
         if current_user.customer? && current_user.userable.invoices.include?(@invoice)
             if(@invoice.destroy)
                render json:{ message: "Invoice Deleted successfully"},status:200 #ok
             else
                render json:{error: @invoice.errors.full_messages}, status:422#unprocessable_entity
            end
       
        else
            render json:{message:"Forbidden Access to Delete the Invoice"}, status:403 #forbidden      
        end
 end




   private
   def create_params
        params.require( :invoice).permit(:cust_email , :purchase_date,:product_id)
   end

   def set_invoice
     @invoice=Invoice.find_by(id: params[:id])
     if ! @invoice
        render json: {error: "No Invoices Found with given Id #{params[:id]}" }, status:404
        return
     end

    end
   

end
      
