class Api::InvoicesController < Api::ApiController
   before_action :set_invoice, only: %i[show  update destroy]
    def index 
    @invoices=Invoice.all
                if @invoices
                    render json: @invoices, status: 200 #ok
                else
                     render json: {message: "No Invoices Found"}, status:204 #no_content
                end
     end
  def create
     product=Product.find_by(id: params[:invoice][:product_id])
     @customer =Customer.find_by(email: params[:invoice][:cust_email])
     if product
        if @customer
            @invoice=Invoice.new(create_params)
            @invoice.customer_id=@customer.id   
            if (@invoice.save)
                render json:@invoice, status: 201#created
            else
                render json:{error: @invoice.errors.full_messages},  status:422 #unprocessable_entity
            end
        else
            render json:{error: "No Customer Found with Given Email #{params[:invoice][:cust_email]}"}, status: 404#not_found
        end
     else
         render json:{error: "No product Found with Given ID #{params[:invoice][:product_id]}"}, status: 404#not_found
     end
               
  end  
  
 def show
     if @invoice
        render json: @invoice , status:200 #ok
     else
         render json:{message:"Invoice Not Found for Id#{params[:id]}"}, status:404 #not_found
     end
 end
              
def update
    if @invoice    
        if(@invoice.update(create_params))
           render json:@invoice , status: 202#accepted
        else
           render json:{error: @invoice.errors.full_messages}, status:422 #unprocessable_entity
         end
     else
        render json:{error: "No Invoice Found with given Id#{params[:id]}"}, status:404 #not_found
     end
end
 def destroy
               
         if @invoice
             if(@invoice.destroy)
                render json:{ message: "Invoice Deleted successfully"},status:200 #ok
             else
                render json:{error: @invoice.errors.full_messages}, status:422#unprocessable_entity
            end
       
        else
              render json:{error: "No Invoice Found with Given ID #{params[:id]}"}, status: 404#not_found
        end
 end




   private
   def create_params
        params.require( :invoice).permit(:cust_email , :purchase_date,:product_id)
   end

   def set_invoice
     @invoice=Invoice.find_by(id: params[:id])
    end
   

end
      
