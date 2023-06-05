require 'rails_helper'

RSpec.describe "Api::CustomersControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}
    let!(:customer1){create(:customer)}
    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)} 

    describe "get /customers#index" do
        
        context "when user is not authenticated" do
            before do 
              get '/api/customers'
            end
            it "returns status 401" do
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            before do 
               get "/api/customers" , params: { access_token: customer_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do 
               get "/api/customers" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /customers#show" do
      
      
        context "when user is not authenticated" do
          before do 
             get '/api/customers/41'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses show" do
          before do 
             get "/api/customers/#{customer.id}" , params: { access_token: seller_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
        context "when authenticated customer_user accesses show with invalid id"  do
          before do 
             get "/api/customers/#{customer.id + 23 }" , params: { access_token: customer_user_token.token}
          end
          it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end
  
        context "when authenticated customer_user accesses show" do
          before do 
             get "/api/customers/#{customer.id}" , params: { access_token: customer_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
    end

    
    describe "patch /customers#update" do

        context "when user is not authenticated" do
          before do 
             patch '/api/customers/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses update" do
          before do 
             patch "/api/customers/#{customer.id}" , params: { access_token: seller_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses update with invalid params" do
          before do 
             patch "/api/customers/#{customer.id}" , params: {access_token: customer_user_token.token , customer:{name: nil}}
          end
          it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated customer_user accesses update with valid params" do
          before do 
             patch "/api/customers/#{customer.id}" , params: {access_token: customer_user_token.token ,  customer:{name: "Customer A"}}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
        context "when authenticated customer_user accesses update with invalid Id" do
          before do 
             patch "/api/customers/#{customer.id + 300}" , params: {access_token: customer_user_token.token ,  customer:{name: "Customer A"}}
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
      end


      describe "delete /customers#destroy" do

        context "when user is not authenticated" do
          before do 
             delete '/api/customers/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses delete customer" do
          before do 
             delete "/api/customers/#{customer.id}" , params: { access_token: seller_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses delete with invalid id" do
          before do 
             delete "/api/customers/#{customer.id + 404 }" , params: {access_token: customer_user_token.token }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
        context "when authenticated customer_user accesses delete another customer" do
          before do 
             delete "/api/customers/#{customer1.id }" , params: {access_token: customer_user_token.token }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end
  
        context "when authenticated customer_user deleted successfully " do
          before do 
             delete "/api/customers/#{customer.id}" , params: {access_token: customer_user_token.token ,  customer:{name: "Customer A"}}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end
  
      describe "get /customers#customer_invoices" do
      
      
        context "when user is not authenticated" do
          before do 
             get '/api/customers/customer_invoices'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses  customer invoices" do
          before do 
             get "/api/customers/customer_invoices" , params: { access_token: seller_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses customer invoices" do
          before do 
             get "/api/customers/customer_invoices" , params: { access_token: customer_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
    end
  
      


end
