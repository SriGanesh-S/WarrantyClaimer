class CustomersController < ApplicationController
  #show all the customers in DB
    def index 
        @customers=Customer.all
    end
  #used to instantiate a customer
    def new
        @customer=Customer.new

    end
  #used to insert the new record in DB
    def create
        @customer=Customer.new(customer_params)
        if(@customer.save)
            redirect_to change_primary_address_path
        else
            render :new
        end

    end
  #used to display aparticular record
    def show
        @customer=Customer.find(params[:id])
    end
  #used to fetch the record to edit
    def edit
        @customer=Customer.find(params[:id])
    end
  #saves the changes to DB
    def update
        @customer=Customer.find(params[:id])
        if(@customer.update(customer_params))
            redirect_to cust_dashboard_path
        else
            render :edit 
        end
    end
  #deletes a record from DB
    def destroy
        @customer=Customer.find(params[:id])
        if(@customer.destroy)
            redirect_to customers_path
        else
            render :edit 
        end
    end

    def dashboard
        @invoices = current_user.userable.invoices

    end

 private
    def customer_params
        params.require( :customer).permit(:name, :email,:age,:gender,:phone_no)
    end

end