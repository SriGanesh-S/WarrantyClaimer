class ProductsController < ApplicationController
 before_action :set_product, only: %i[show edit update destroy]
           #show all the products in DB
           before_action :authenticate_user!
           before_action :authorize_seller, only: %i[ new index edit destroy ]
         def index 
            @products=current_user.userable.products
         end
       #used to instantiate a product
         def new
             @product=Product.new
         end
       #used to insert the new record in DB
         def create
             @product=Product.new(product_params)
             @product.seller_id=current_user.userable_id
             if(@product.save)
                 flash[:notice]="Product created successfully: "
                 redirect_to seller_dashboard_path
             else
                 render :new
             end
     
         end
       #used to display a particular record
         def show
          unless current_user.userable.products.include?(@product)
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
          end
         end
       #used to fetch the record to edit
         def edit
          unless current_user.userable.products.include?(@product)
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
          end
         end
       #saves the changes to DB
         def update
              @product.seller_id = current_user.userable_id
             if(@product.update(product_params))
                 redirect_to products_path
             else
                 render :edit 
             end
         end
       #deletes a record from DB
         def destroy
          unless current_user.userable.products.include?(@product)
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
          end
           if @product.invoices
            flash[:notice] = "You can't delete a product if it's sold."
            redirect_to root_path

           elsif(@product.destroy)
                 redirect_to products_path
           else
                 render :edit 
            end
         end
     
      private
         def set_product
             @product=Product.find_by(id: params[:id])
         end
         def product_params
             params.require( :product).permit(:name, :category)
         end

         def authorize_seller
          unless current_user.seller?
            flash[:notice] = "You are not authorized to perform this action."
            redirect_to root_path
          end
        end
     
end
   
        