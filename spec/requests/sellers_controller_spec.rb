require 'rails_helper'

RSpec.describe "Api::SellersControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)} 

    describe "get /sellers#index" do
        
        context "when user is not authenticated" do
            it "returns status 401" do
              get '/api/sellers'
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            it "returns status 200" do
                get "/api/sellers" , params: { access_token: customer_user_token.token}
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            it "returns status 200" do
                get "/api/sellers" , params: { access_token: seller_user_token.token}
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /sellers#show" do
      
      
        context "when user is not authenticated" do
          it "returns status 401" do
            get '/api/sellers/41'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          it "returns status 403" do
            get "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token }
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          it "returns status 200" do
            get "/api/sellers/#{seller.id}" , params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
    end

    
    describe "patch /sellers#update" do

        context "when user is not authenticated" do
          it "returns status 401" do
            patch '/api/sellers/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          it "return status code 403" do
            patch "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          it "return status 422" do
            patch "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token , seller:{name: nil}}
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          it "return status 202" do
            patch "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token ,  seller:{name: "Seller A"}}
            expect(response).to have_http_status(202)
          end
  
        end
  
      end


      describe "delete /sellers#destroy" do

        context "when user is not authenticated" do
          it "returns status 401" do
            delete '/api/sellers/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          it "return status code 403" do
            delete "/api/sellers/#{seller.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses delete another seller product" do
          it "return status 403" do
            delete "/api/sellers/#{seller.id + 1}" , params: {access_token: seller_user_token.token }
            expect(response).to have_http_status(403)
          end
  
        end
  
        context "when authenticated seller_user deleted successfully " do
          it "return status 200" do
            delete "/api/sellers/#{seller.id}" , params: {access_token: seller_user_token.token }
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


      describe "get /sellers#seller_products" do
      
      
        context "when user is not authenticated" do
          it "returns status 401" do
            get '/api/sellers/41'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses seller products" do
          it "returns status 403" do
            get "/api/sellers/seller_products" , params: { access_token: customer_user_token.token }
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses seller products" do
          it "returns status 200" do
            get "/api/sellers/seller_products", params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
    end

  



end