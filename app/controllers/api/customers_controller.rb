class Api::CustomersController < Api::ApiController
  #show all the customers in DB
    def index 
        @customers=Customer.all
        if @customers
        render json: @customers, status: 200 #ok
        else
         render json: {message: "No Customers Found"}, status:204 #no_content
        end
    end

  #used to insert the new record in DB
    def create
        @customer=Customer.new(customer_params)
        if(@customer.save)
            render json:@customer , status: 201#created
        else
            render json:{error: @customer.error.full_messages},status:422 #unprocessable_entity
        end

    end
  #used to display aparticular record
    def show
        @customer=Customer.find_by(id: params[:id])
        if @customer
            render json: @customer , status:200 #ok
        else
            render json:{message:"Customer Not Found"}, status:404 #not_found
        end

    end
  
  #saves the changes to DB
    def update
        @customer=Customer.find_by(id: params[:id])
        if @customer
            if(@customer.update(customer_params))
              render json:@customer , status:202
            else
              render json:{error: @customer.errors.full_messages}, status:422 #unprocessable_entity
            end
        else
            render json:{error: "No Customer Found with given Id#{params[:id]}"}, status:404 #not_found

        end
    end
  #deletes a record from DB
    def destroy
        @customer=Customer.find_by(id: params[:id])
        if @customer
        
         if(@customer.destroy)
            render json:{ message: "Customer Deleted successfully"},status:200 #ok
         else
            render json:{error: @customer.errors.full_messages}, status:422#unprocessable_entity
         end
        else
            render json:{error: "No Customer Found with Given ID #{params[:id]}"}, status: 404#not_found

        end
    end

    def customer_invoices
     @customer=Customer.find_by(id: params[:id])
      if @customer

        @invoices = Invoice.where(customer_id: params[:id])
        if @invoices
            render json:@invoices , status:200
        else
            render json:{message:"No Invoices For given Customer Id #{params[:id]}"},status:204 #no_content

        end 
        
      else
        render json:{error: "No Customer Found with Given ID #{params[:id]}"}, status: 404#not_found 
      end
    end

 private
    def customer_params
        params.require( :customer).permit(:name, :email,:age,:gender,:phone_no,:primary_address_id)
    end

end