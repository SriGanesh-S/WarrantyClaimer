class CustomersController < ApplicationController
  #show all the customers in DB
  before_action :authorize_customer, only: %i[  edit destroy ]
  
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
        @customer=Customer.find_by(id: params[:id])
        unless current_user.userable.include?(@customer)
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
        end
    end
  #used to fetch the record to edit
    def edit
        @customer=Customer.find_by(id: params[:id])
        unless current_user.userable.include?(@customer)
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
        end
    end
  #saves the changes to DB
    def update
        
        @customer=Customer.find_by(id: params[:id])
        if(@customer.update(customer_params))
            redirect_to cust_dashboard_path
        else
            render :edit 
        end
    end
  #deletes a record from DB
    def destroy
        @custome=current_user.userable
        if(@customer.destroy)
            redirect_to root_path
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

    def authorize_customer
        unless current_user.customer?
          flash[:notice] = "You are not authorized to perform this action."
          redirect_to root_path
        end
      end

end