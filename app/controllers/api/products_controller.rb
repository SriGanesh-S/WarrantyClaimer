class Api::ProductsController < Api::ApiController
 before_action :set_product, only: %i[show update destroy]
           #show all the products in DB
           
         def index 
           if current_user.seller?
            @products=current_user.userable.products
            if @products
              render json: @products, status: 200 #ok
              else
               render json: {message: "No products Found"}, status:204 #no_content
              end
          else
              render json:{error: "Forbidden Access You Must be a Seller"}, status: 403#forbidden
  
           end
         end
    
       #used to insert the new record in DB
         def create
             if current_user.seller?
               @product=Product.new(product_params)
               @product.seller_id=current_user.userable_id
               if(@product.save)
                render json:@product , status: 201#created
               else
                render json:{error: @product.errors.full_messages},status:422 #unprocessable_entity
               end
             else
              render json:{error: "Forbidden Access You Must be a seller"}, status: 403#forbidden
            end
     
         end
       #used to display a particular record
        def show

         if current_user.userable.products.include?(@product)
           if @product
             render json: @product , status:200 #ok
           else
             render json:{message:"Product Not Found for Id#{params[:id]}"}, status:404 #not_found
           end
         else
          render json:{error: "Forbidden Access to Product"}, status: 403#forbidden

          end

         end
       
       #saves the changes to DB
         def update
          if current_user.userable.products.include?(@product)
          if @product    
             if(@product.update(product_params))
                 render json:@product , status: 202#accepted
             else
                 render json:{error: @product.errors.full_messages}, status:422 #unprocessable_entity
             end
          else
            render json:{error: "No Product Found with given Id#{params[:id]}"}, status:404 #not_found
          end
        else
          render json:{error: "Forbidden Access to Product"}, status: 403

          end

         end
       #deletes a record from DB
         def destroy
          if current_user.userable.products.include?(@product)
          if @product
             if(@product.destroy)
               render json:{ message: "Product Deleted successfully"},status:200 #ok
             else
               render json:{error: @product.errors.full_messages}, status:422#unprocessable_entity
             end

          else
            render json:{error: "No Product Found with Given ID #{params[:id]}"}, status: 404#not_found
          end
        else
          render json:{error: "Forbidden Access to Product"}, status: 403#forbidden

          end
         
        end
     
      private
         def set_product
             @product=Product.find_by(id: params[:id])
         end
         def product_params
             params.require( :product).permit(:name, :category)
         end
     
end
   
        