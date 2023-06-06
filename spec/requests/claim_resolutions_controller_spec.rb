require 'rails_helper'

RSpec.describe "Api::ClaimResolutionsControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let!(:product){create(:product,seller: seller )} 
    let!(:invoice){create(:invoice, customer:customer , product:product)}
    let!(:warranty_claim){create(:warranty_claim,invoice: invoice)}
    let!(:claim_resolution){create(:claim_resolution, warranty_claim: warranty_claim)}
    let!(:resolution){create(:claim_resolution)}
    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)}
  

    describe "get /claim_resolutions#index" do
        
        context "when user is not authenticated" do
            before do
               get '/api/claim_resolutions'
            end
            it "returns status 401" do
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            before do
                 get "/api/claim_resolutions" , params: { access_token: customer_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do
                 get "/api/claim_resolutions" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /claim_resolutions#show" do
      
      
        context "when user is not authenticated" do
          before do
               get '/api/claim_resolutions/41'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          before do
               get "/api/claim_resolutions/#{claim_resolution.id}" , params: { access_token: customer_user_token.token }
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          before do
               get "/api/claim_resolutions/#{claim_resolution.id}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when authenticated seller_user accesses show for invalid reesolution" do
          before do
               get "/api/claim_resolutions/#{claim_resolution.id + 345}" , params: { access_token: seller_user_token.token}
          end
          it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end
        context "when authenticated seller_user accesses show for other's reesolution" do
          before do
               get "/api/claim_resolutions/#{resolution.id }" , params: { access_token: seller_user_token.token}
          end
          it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end

    end



    describe "post /claim_resolutions#create" do
      context "when user is not authenticated" do
        before do
             post '/api/claim_resolutions/'
        end
        it "returns status 401" do
          expect(response).to have_http_status(401)
        end
      end

      context "when authnticated customer_user accesses create" do
        before do
             post "/api/claim_resolutions/" , params: { access_token: customer_user_token.token,claim_resolution:{status: nil, description:"", warranty_claim_id: warranty_claim.id}}
        end
        it "return status code 403" do
          expect(response).to have_http_status(403)
        end
      end

      context "when authenticated seller_user creates resolutions with invalid params" do
        before do
             post "/api/claim_resolutions/" , params: {access_token: seller_user_token.token , claim_resolution:{status: nil, description:"", warranty_claim_id: warranty_claim.id}}
        end
        it "return status 422" do
          expect(response).to have_http_status(422)
        end

      end

      context "when authenticated seller_user accesses creates resolutions with valid params" do
        before do
             post"/api/claim_resolutions/" , params: {access_token: seller_user_token.token ,  claim_resolution:{status:"Accepted", description:"Our team will validate your claim", warranty_claim_id: warranty_claim.id}}
        end
        it "return status 200" do
          expect(response).to have_http_status(200)
        end

      end

    end

    
    describe "patch /claim_resolutions #update" do
        context "when user is not authenticated" do
          before do
               patch '/api/claim_resolutions/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          before do
               patch "/api/claim_resolutions/#{claim_resolution.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          before do
               patch "/api/claim_resolutions/#{claim_resolution.id}" , params: {access_token: seller_user_token.token , claim_resolution:{description: nil}}
          end
          it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated customer_user accesses update with valid params" do
          before do
               patch "/api/claim_resolutions/#{claim_resolution.id}" , params: {access_token: seller_user_token.token ,  claim_resolution:{description: "Updated description for claim request of the product "}}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end

        context "when authenticated seller_user accesses update invalid resolutions" do
          before do
               patch "/api/claim_resolutions/#{claim_resolution.id + + 45678}" , params: {access_token: seller_user_token.token   }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user accesses update other seller resolutions" do
          before do
               patch "/api/claim_resolutions/#{resolution.id}" , params: {access_token: seller_user_token.token  }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end
      end


      describe "delete /#destroy" do

        context "when user is not authenticated" do
          before do
               delete '/api/claim_resolutions/32'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          before do
               delete "/api/claim_resolutions/#{claim_resolution.id}" , params: { access_token: customer_user_token.token}
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses delete another seller claim resolution" do
          before do
               delete "/api/claim_resolutions/#{resolution.id }" , params: {access_token: seller_user_token.token }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end
        context "when authenticated seller_user accesses delete invalid claim resolution" do
          before do
               delete "/api/claim_resolutions/#{resolution.id + 333 }" , params: {access_token: seller_user_token.token }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user deleted claim successfully " do
          before do
               delete "/api/claim_resolutions/#{claim_resolution.id}" , params: {access_token: seller_user_token.token }
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end

      describe "patch  #default_claim_resolution" do
        context "when user is not authenticated" do
          before do
               patch '/api/claim_resolutions/default_claim_resolution'
          end
          it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses default_claim_resolution" do
          before do
               patch "/api/claim_resolutions/default_claim_resolution" , params: { access_token: customer_user_token.token , claim_resolution_id:claim_resolution.id }
          end
          it "return status code 403" do
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update other seller's resolutions" do
          before do
               patch "/api/claim_resolutions/default_claim_resolution" , params: {access_token: seller_user_token.token , claim_resolution_id:resolution.id }
          end
          it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end

        context "when authenticated seller_user accesses update invalid resolutions" do
          before do
               patch "/api/claim_resolutions/default_claim_resolution" , params: {access_token: seller_user_token.token , claim_resolution_id:claim_resolution.id + 56 }
          end
          it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user accesses set resolutions to default " do
          before do
               patch "/api/claim_resolutions/default_claim_resolution" , params: {access_token: seller_user_token.token , claim_resolution_id:claim_resolution.id}
          end
          it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end
  
      end
   
  



end
