class Api::ProductsController < Api::ApiController
 before_action :set_product, only: %i[show update destroy]
           #show all the products in DB
           
         def index 
            @products=Product.all
            if @products
              render json: @products, status: 200 #ok
              else
               render json: {message: "No products Found"}, status:204 #no_content
              end
         end
    
       #used to insert the new record in DB
         def create
            
             @seller_id=Seller.find_by(id: params[:product][:seller_id])
            
             if @seller_id
               @product=Product.new(product_params)
               if(@product.save)
                render json:@product , status: 201#created
               else
                render json:{error: @product.errors.full_messages},status:422 #unprocessable_entity
               end
             else
              render json:{error: "No Seller Found with Given ID #{params[:seller_id]}"}, status: 404#not_found
            end
     
         end
       #used to display a particular record
         def show
          if @product
            render json: @product , status:200 #ok
          else
            render json:{message:"Product Not Found for Id#{params[:id]}"}, status:404 #not_found
          end
         end
       
       #saves the changes to DB
         def update
          if @product    
             if(@product.update(product_params))
                 render json:@product , status: 202#accepted
             else
                 render json:{error: @product.errors.full_messages}, status:422 #unprocessable_entity
             end
          else
            render json:{error: "No Product Found with given Id#{params[:id]}"}, status:404 #not_found
          end

         end
       #deletes a record from DB
         def destroy
          if @product
             if(@product.destroy)
               render json:{ message: "Product Deleted successfully"},status:200 #ok
             else
               render json:{error: @product.errors.full_messages}, status:422#unprocessable_entity
             end

          else
            render json:{error: "No Product Found with Given ID #{params[:id]}"}, status: 404#not_found
          end
         
        end
     
      private
         def set_product
             @product=Product.find_by(id: params[:id])
         end
         def product_params
             params.require( :product).permit(:name, :category,:seller_id)
         end
     
end
   
        