require 'rails_helper'

RSpec.describe "Api::SellersControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}
    let!(:seller1){create(:seller)}
    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)} 

    describe "get /sellers#index" do
        
        context "when user is not authenticated" do
            before do 
              get '/api/sellers'
            end
            it "returns status 401" do
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            before do 
               get "/api/sellers" , params: { access_token: customer_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do 
               get "/api/sellers" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /sellers#show" do
      
      
        context "when user is not authenticated" do
          before do 
             get '/api/sellers/41'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          before do 
             get "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          before do 
             get "/api/sellers/#{seller.id}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when authenticated seller_user accesses with invalid Id" do
          before do 
             get "/api/sellers/#{seller.id + 234}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end
        context "when authenticated seller_user accesses others profile" do
          before do 
             get "/api/sellers/#{seller1.id }" , params: { access_token: seller_user_token.token}
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
    end

    
    describe "patch /sellers#update" do

        context "when user is not authenticated" do
          before do 
             patch '/api/sellers/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          before do 
             patch "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          before do 
             patch "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token , seller:{name: nil}}
          end
          it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
        context "when authenticated seller_user accesses update with invalid Id" do
          before do 
             patch "/api/sellers/#{seller.id + 234}" , params: {access_token: seller_user_token.token , seller:{name: nil}}
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          before do 
             patch "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token ,  seller:{name: "Seller A"}}
          end
          it "return status 202" do
            expect(response).to have_http_status(202)
          end
  
        end
  
      end


      describe "delete /sellers#destroy" do

        context "when user is not authenticated" do
          before do 
             delete '/api/sellers/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          before do 
             delete "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses delete another seller " do
          before do 
             delete "/api/sellers/#{seller1.id }" , params: {access_token: seller_user_token.token }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end

        context "when authenticated seller_user accesses delete with invaid id" do
          before do 
             delete "/api/sellers/#{seller.id + 234 }" , params: {access_token: seller_user_token.token }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user deleted successfully " do
          before do 
             delete "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token }
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


      describe "get /sellers#seller_products" do
      
      
        context "when user is not authenticated" do
          before do 
             get "/api/sellers/#{seller.id}"
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses seller products" do
          before do 
             get "/api/sellers/seller_products" , params: { access_token: customer_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses seller products" do
          before do 
             get "/api/sellers/seller_products", params: { access_token: seller_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
    end


end
