require 'rails_helper'

RSpec.describe "Api::ProductsControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let!(:product){create(:product,seller: seller )} 
    let!(:product1){create(:product )} 
    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)}
  

    describe "get /products#index" do
        
        context "when user is not authenticated" do
            before do
              get '/api/products'
            end
            it "returns status 401" do
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            before do
               get "/api/products" , params: { access_token: customer_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do
               get "/api/products" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /products#show" do
      
      
        context "when user is not authenticated" do
          before do
             get '/api/products/41'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          before do
             get "/api/products/#{product.id}" , params: { access_token: customer_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          before do
             get "/api/products/#{product.id}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when authenticated seller_user accesses show with invalid Id" do
          before do
             get "/api/products/#{product.id + 1000 }" , params: { access_token: seller_user_token.token}
          end
          it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end
    end

    describe "post /products#create" do
      context "when user is not authenticated" do
        before do
           post '/api/products/'
        end
        it "returns status 401" do
          expect(response).to have_http_status(401)
        end
      end

      context "when authnticated customer_user accesses create" do
        before do
           post "/api/products/" , params: { access_token: customer_user_token.token}
        end
        it "return status code 403" do
          expect(response).to have_http_status(403)
        end
      end

      context "when authenticated seller_user creates product with invalid params" do
        before do
           post "/api/products/" , params: {access_token: seller_user_token.token , product:{name: nil, category:"", seller: seller}}
        end
        it "return status 422" do
          expect(response).to have_http_status(422)
        end

      end

      context "when authenticated seller_user accesses creates product with valid params" do
        before do
           post"/api/products/" , params: {access_token: seller_user_token.token ,  product:{name: "product A", category:"category A", seller: seller}}
        end
        it "return status 200" do
          expect(response).to have_http_status(200)
        end

      end

    end





    
    describe "patch /products#update" do
        context "when user is not authenticated" do
          before do
             patch '/api/products/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          before do
             patch "/api/products/#{product.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          before do
             patch "/api/products/#{product.id}" , params: {access_token: seller_user_token.token , product:{name: nil}}
          end
          it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end

        context "when authenticated seller_user accesses update with invalid Id" do
          before do
             patch "/api/products/#{product.id + 3456 }" , params: {access_token: seller_user_token.token , product:{name: nil}}
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
  
        context "when authenticated seller_user accesses update with valid params" do
          before do
             patch "/api/products/#{product.id}" , params: {access_token: seller_user_token.token ,  product:{name: "product A"}}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


      describe "delete /products#destroy" do

        context "when user is not authenticated" do
          before do
             delete '/api/products/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          before do
             delete "/api/products/#{product.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses delete another customer" do
          before do
             delete "/api/products/#{product1.id }" , params: {access_token: seller_user_token.token }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end

        context "when authenticated seller_user accesses delete for invalid product" do
          before do
             delete "/api/products/#{product1.id + 345 }" , params: {access_token: seller_user_token.token }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user deleted successfully " do
          before do
             delete "/api/products/#{product.id}" , params: {access_token: seller_user_token.token }
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


   
  



end
