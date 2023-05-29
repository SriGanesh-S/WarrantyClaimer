require 'rails_helper'

RSpec.describe "Api::ProductsControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let!(:product){create(:product,seller: seller )} 

    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)}
  

    describe "get /products#index" do
        
        context "when user is not authenticated" do
            it "returns status 401" do
              get '/api/products'
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            it "returns status 200" do
                get "/api/products" , params: { access_token: customer_user_token.token}
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            it "returns status 200" do
                get "/api/products" , params: { access_token: seller_user_token.token}
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /products#show" do
      
      
        context "when user is not authenticated" do
          it "returns status 401" do
            get '/api/products/41'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          it "returns status 403" do
            get "/api/products/#{product.id}" , params: { access_token: customer_user_token.token }
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          it "returns status 200" do
            get "/api/products/#{product.id}" , params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
    end

    describe "post /products#create" do
      context "when user is not authenticated" do
        it "returns status 401" do
          post '/api/products/'
          expect(response).to have_http_status(401)
        end
      end

      context "when authnticated customer_user accesses create" do
        it "return status code 403" do
          post "/api/products/" , params: { access_token: customer_user_token.token}
          expect(response).to have_http_status(403)
        end
      end

      context "when authenticated seller_user creates product with invalid params" do
        it "return status 422" do
          post "/api/products/" , params: {access_token: seller_user_token.token , product:{name: nil, category:"", seller: seller}}
          expect(response).to have_http_status(422)
        end

      end

      context "when authenticated seller_user accesses creates product with valid params" do
        it "return status 202" do
          post"/api/products/" , params: {access_token: seller_user_token.token ,  product:{name: "product A", category:"category A", seller: seller}}
          expect(response).to have_http_status(201)
        end

      end

    end





    
    describe "patch /products#update" do
        context "when user is not authenticated" do
          it "returns status 401" do
            patch '/api/products/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          it "return status code 403" do
            patch "/api/products/#{product.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          it "return status 422" do
            patch "/api/products/#{product.id}" , params: {access_token: seller_user_token.token , product:{name: nil}}
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          it "return status 202" do
            patch "/api/products/#{product.id}" , params: {access_token: seller_user_token.token ,  product:{name: "product A"}}
            expect(response).to have_http_status(202)
          end
  
        end
  
      end


      describe "delete /products#destroy" do

        context "when user is not authenticated" do
          it "returns status 401" do
            delete '/api/products/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          it "return status code 403" do
            delete "/api/products/#{product.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses delete another customer" do
          it "return status 403" do
            delete "/api/products/#{product.id + 1}" , params: {access_token: seller_user_token.token }
            expect(response).to have_http_status(403)
          end
  
        end
  
        context "when authenticated seller_user deleted successfully " do
          it "return status 200" do
            delete "/api/products/#{product.id}" , params: {access_token: seller_user_token.token }
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


   
  



end
