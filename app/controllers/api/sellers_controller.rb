class Api::SellersController < Api::ApiController
   before_action :set_seller, only: %i[show  update destroy]
      #show all the seller in DB
    def index 
        sellers=Seller.all
        if sellers
          render json: sellers, status: 200 #ok
          else
           render json: {message: "No Sellers Found"}, status:204 #no_content
          end
    end
  
  #used to insert the new record in DB
    def create
        seller=Seller.new(seller_params)
        
        if(seller.save)
            render json:seller , status: 201#created
        else
            render json:{error: seller.errors.full_messages},status:422 #unprocessable_entity
        end

    end
 
    def show
      if seller
        if seller.id==current_user.userable_id
           render json: seller , status:200 #ok

         else
           render json:{message:"Unauthorised Access to the profile"}, status:401 #not_found
         end
      else
        render json:{message:"Seller Not Found"}, status:404 #not_found
      end
    end

  #saves the changes to DB
    def update
      if seller
        if seller.id==current_user.userable_id && current_user.seller?
      
          if(seller.update(seller_params))
            render json:seller , status:202#accepted
          else
            render json:{error: seller.errors.full_messages}, status:422 #unprocessable_entity
           end
        else
          render json:{message:"Unauthorised Access to update the profile"}, status:401 #unauthorized
        end
      else
        render json:{error: "No seller Found with given Id#{params[:id]}"}, status:404 #not_found

      end
    end
  #deletes a record from DB
    def destroy
       
      if seller
        if seller.id==current_user.userable_id && current_user.seller?
           if(seller.destroy)
             render json:{ message: "Seller Deleted successfully"},status:200 #ok
           else
             render json:{error: seller.errors.full_messages}, status:422#unprocessable_entity
            end
        else
            render json:{message:"Unauthorised Access to delete the profile"}, status:401 #unauthorized
        end

      else
           render json:{error: "No Seller Found with Given ID #{params[:id]}"}, status: 404#not_found

      end
      
    end

    
    def seller_products
      seller=Seller.find_by(id: current_user.userable_id )
      if seller && current_user.seller?
        products = Product.where(seller_id: params[:id])
        if products
          render json:products , status:200
        else
          render json:{message:"No products For given Seller Id #{params[:id]}"},status:204 #no_content

        end  
      else
        render json:{message:"Unauthorised Access to the profile"}, status:401 #unauthorized
      end
    end
        
    
    

 private
    def set_seller
        seller=Seller.find_by(id: params[:id])
    end
    def seller_params
        params.require( :seller).permit(:name, :email,:organisation_name,:designation,:description,:primary_address_id,:phone_no)
    end
end