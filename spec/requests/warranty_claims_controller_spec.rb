require 'rails_helper'

RSpec.describe "Api::WarrantyClaimsControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let!(:product){create(:product,seller: seller )} 
    let!(:invoice){create(:invoice, customer:customer , product:product)}
    let!(:warranty_claim){create(:warranty_claim,invoice: invoice)}
    let!(:warranty_claim1){create(:warranty_claim)}
    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)}
  

    describe "get /warranty_claims#index" do
        
        context "when user is not authenticated" do
            before do 
              get '/api/warranty_claims'
            end
            it "returns status 401" do
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            before do 
               get "/api/warranty_claims" , params: { access_token: customer_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do 
               get "/api/warranty_claims" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end


    
    describe "get /warranty_claims#show" do
      
      
        context "when user is not authenticated" do
          before do 
             get '/api/warranty_claims/41'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authenticated customer_user accesses show" do
          before do 
             get "/api/warranty_claims/#{warranty_claim.id}" , params: { access_token: customer_user_token.token }
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end


        context "when authenticated customer_user accesses show with invalid Id" do
          before do 
            get "/api/warranty_claims/#{warranty_claim.id + 23 }" , params: { access_token: customer_user_token.token }
          end
          it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end
        context "when authenticated user accesses other's claim" do
          before do 
             get "/api/warranty_claims/#{warranty_claim1.id}" , params: { access_token: customer_user_token.token }
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          before do 
             get "/api/warranty_claims/#{warranty_claim.id}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
    end

    

    describe "post /warranty_claims #create" do
      context "when user is not authenticated" do
        before do 
           post '/api/warranty_claims'
        end
        it "returns status 401" do
          expect(response).to have_http_status(401)
        end
      end

      context "when authnticated seller_user accesses create" do
        before do 
           post "/api/warranty_claims/" , params: { access_token: seller_user_token.token, warranty_claim:{problem_description: nil, invoice_id:invoice.id}}
        end
        it "return status code 403" do
          expect(response).to have_http_status(403)
        end
      end

      context "when authenticated customer_user creates  with invalid params" do
        before do 
           post "/api/warranty_claims/" , params: {access_token: customer_user_token.token , warranty_claim:{problem_description: nil, invoice_id:invoice.id}}
        end
        it "return status 422" do
          expect(response).to have_http_status(422)
        end

      end

      context "when authenticated customer_user creates claim with valid params" do
        before do 
           post "/api/warranty_claims/" , params: {access_token: customer_user_token.token ,  warranty_claim:{problem_description: " problems & issues of the product ", invoice_id: invoice.id }}
        end
        it "return status 200" do
          expect(response).to have_http_status(200)
        end

      end

    end









    describe "patch /warranty_claims #update" do
        context "when user is not authenticated" do
          before do 
             patch '/api/warranty_claims/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses update" do
          before do 
             patch "/api/warranty_claims/#{warranty_claim.id}" , params: { access_token: seller_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses update with invalid params" do
          before do 
             patch "/api/warranty_claims/#{warranty_claim.id}" , params: {access_token: customer_user_token.token , warranty_claim:{problem_description: nil}}
          end
          it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
        context "when authenticated customer_user accesses update with invalid Id" do
          before do 
             patch "/api/warranty_claims/#{warranty_claim.id + 234}" , params: {access_token: customer_user_token.token , warranty_claim:{problem_description: nil}}
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated customer_user accesses update with valid params" do
          before do 
             patch "/api/warranty_claims/#{warranty_claim.id}" , params: {access_token: customer_user_token.token ,  warranty_claim:{problem_description: "Updated problem issues of the product "}}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


      describe "delete /#destroy" do

        context "when user is not authenticated" do
          before do 
             delete '/api/warranty_claims/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses delete" do
          before do 
             delete "/api/warranty_claims/#{warranty_claim.id}" , params: { access_token: seller_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses delete another customer claim" do
          before do 
             delete "/api/warranty_claims/#{warranty_claim1.id }" , params: {access_token: customer_user_token.token }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end
        context "when authenticated customer_user accesses delete with invalid Id" do
          before do 
             delete "/api/warranty_claims/#{warranty_claim.id + 2334 }" , params: {access_token: customer_user_token.token }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated customer_user deleted claim successfully " do
          before do 
             delete "/api/warranty_claims/#{warranty_claim.id}" , params: {access_token: customer_user_token.token }
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
        
  
      end


   
  



end
