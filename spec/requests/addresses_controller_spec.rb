require 'rails_helper'

RSpec.describe "Api::AddressesControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}
    let! (:seller_address){create(:address,:for_sellers , addressable: seller )}
    let! (:customer_address){create(:address,:for_customers , addressable: customer )}
    let! (:address2){create(:address,:for_sellers  )}
    let! (:address3){create(:address,:for_customers  )}

    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)} 

    describe "get /addresses#index" do
        
        context "when user is not authenticated" do
          before do
             get '/api/addresses'
          end

          it "returns status 401" do
              expect(response).to have_http_status(401)
          end

        end

          context "when  customer user is authenticated" do
             before do
               get "/api/addresses" , params: { access_token: customer_user_token.token}
             end
             it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            before do
             get "/api/addresses" , params: { access_token: seller_user_token.token}
            end
            it "returns status 200" do
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /addresses#show" do
      
      
        context "when user is not authenticated" do
          before do
           get '/api/addresses/41'
          end
           it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
           before do
            get "/api/addresses/#{customer_address.id}" , params: { access_token: customer_user_token.token }
          end
           it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          before do
            get "/api/addresses/#{seller_address.id}" , params: { access_token: seller_user_token.token}
          end
         it "returns status 200" do
            expect(response).to have_http_status(200)
          end
        end

        context "when authnticated customer_user accesses show for invalid address" do
         before do
            get "/api/addresses/#{customer_address.id + 43}" , params: { access_token: customer_user_token.token }
         end
         it "returns status 404" do
            expect(response).to have_http_status(404)
          end
        end


        context "when authnticated customer_user accesses show for other customer address" do
         before do
            get "/api/addresses/#{address3.id }" , params: { access_token: customer_user_token.token }
         end
         it "returns status 403" do
            expect(response).to have_http_status(403)
          end
        end
    end

    
    describe "post /addresses#create" do

        context "when user is not authenticated" do
          before do
            post '/api/addresses'
          end
         it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
       
  
        context "when authenticated seller_user creates with invalid params" do
          before do
            post "/api/addresses/" , params: {access_token: seller_user_token.token , address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: nil, phone: nil, addressable:seller }}
          end
         it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user create with valid params" do
          before do
            post "/api/addresses/" , params: {access_token: seller_user_token.token ,  address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: 641001, phone: 7654321899, addressable:seller }}
          end
         it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end

        context "when authenticated customer_user creates address with invalid params" do
           before do
             post"/api/addresses/" , params: {access_token: customer_user_token.token ,  address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: nil, phone: nil, addressable:customer }}
           end
           it "return status 422" do
              expect(response).to have_http_status(422)
            end
    
          end
    
          context "when authenticated customer_user accesses creates address with valid params" do
            before do
              post "/api/addresses/" , params: {access_token: customer_user_token.token ,address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: 641001, phone: 7654321899, addressable:customer }}
            end
           it "return status 200" do
              expect(response).to have_http_status(200)
            end
    
          end
  
      end



    describe "patch /addresses#update" do

        context "when user is not authenticated" do
          before do
            patch '/api/addresses/32'
          end
         it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
       
  
        context "when authenticated seller_user accesses update with invalid params" do
       before do
          patch "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token , address:{pin_code: nil}}
       end
         it "return status 422" do
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          before do
            patch "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token ,  address:{street: "Street A"}}
          end
         it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end

        context "when authenticated customer_user accesses update with invalid params" do
          before do
            patch "/api/addresses/#{customer_address.id}" , params: {access_token: customer_user_token.token , address:{pin_code: nil}}
          end
           it "return status 422" do
              expect(response).to have_http_status(422)
            end
    
          end
    
          context "when authenticated customer_user accesses update with valid params" do
            before do
               patch "/api/addresses/#{customer_address.id}" , params: {access_token: customer_user_token.token ,  address:{street: "Street A"}}
            end
           it "return status 200" do
              expect(response).to have_http_status(200)
            end
    
          end
  
      end


      describe "delete /addresses#destroy" do

        context "when user is not authenticated" do
          before do
            delete '/api/addresses/32'
          end
         it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
       before do
          delete "/api/addresses/#{customer_address.id}" , params: { access_token: customer_user_token.token}
       end
         it "return status code 200" do
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated customer_user accesses delete another customer Address" do
          before do
            delete "/api/addresses/#{address3.id }" , params: {access_token: customer_user_token.token }
          end
         it "return status 403" do
            expect(response).to have_http_status(403)
          end
  
        end

        context "when authenticated customer_user accesses delete Invalid Address" do
         before do
            delete "/api/addresses/#{address3.id + 23 }" , params: {access_token: customer_user_token.token }
          end
         it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
        end
  
        context "when authenticated seller_user deleted address successfully " do
          before do
              delete "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token }
          end
         it "return status 200" do
            expect(response).to have_http_status(200)
          end
  
        end

        context "when authenticated seller_user accesses delete another seller Address" do
          before do
            delete "/api/addresses/#{address2.id }" , params: {access_token: seller_user_token.token }
          end
           it "return status 403" do
              expect(response).to have_http_status(403)
            end
    
        end

        context "when authenticated seller_user accesses delete Invalid Address" do
          before do
            delete "/api/addresses/#{address2.id + 23 }" , params: {access_token: seller_user_token.token }
          end
         it "return status 404" do
            expect(response).to have_http_status(404)
          end
  
      end

        context "when authenticated customer_user accesses delete another seller Address" do
            before do
               delete "/api/addresses/#{seller_address.id }" , params: {access_token: customer_user_token.token }
            end
           it "return status 403" do
              expect(response).to have_http_status(403)
            end
    
        end

        context "when authenticated seller_user accesses delete another customer Address" do
           before do
              delete "/api/addresses/#{customer_address.id }" , params: {access_token: seller_user_token.token }
            end
           it "return status 403" do
              expect(response).to have_http_status(403)
            end
    
        end
  
      end



      describe "patch /addresses#primary_address" do
        context "when user is not authenticated" do
          before do
            patch '/api/addresses/primary_address'
          end
         it "returns status 401" do
            expect(response).to have_http_status(401)
          end
        end
        context "when authenticated seller_user accesses update with valid address" do
          before do
             patch "/api/addresses/primary_address" , params: {access_token: seller_user_token.token ,  id:seller_address.id }
          end
           it "return status 200" do
              expect(response).to have_http_status(200)
            end
    
          end

          context "when authenticated customer_user accesses update with valid address" do
              before do
                patch "/api/addresses/primary_address" , params: {access_token: customer_user_token.token ,  id:customer_address.id }
              end
           it "return status 200" do
              expect(response).to have_http_status(200)
            end
    
          end

          context "when authenticated customer_user accesses update with other's address" do
            before do
              patch "/api/addresses/primary_address" , params: {access_token: customer_user_token.token ,  id:seller_address.id }
            end
           it "return status 403" do
              expect(response).to have_http_status(403)
            end
    
          end

          context "when authenticated seller_user accesses update with other's address" do
            before do
              patch "/api/addresses/primary_address" , params: {access_token: seller_user_token.token ,  id:customer_address.id }
            end
           it "return status 403" do
              expect(response).to have_http_status(403)
            end
    
          end
  
      end
    
  


  



end
