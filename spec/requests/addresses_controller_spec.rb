require 'rails_helper'

RSpec.describe "Api::AddressesControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}
    let! (:seller_address){create(:address,:for_sellers , addressable: seller )}
    let! (:customer_address){create(:address,:for_customers , addressable: customer )}


    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)} 

    describe "get /addresses#index" do
        
        context "when user is not authenticated" do
            it "returns status 401" do
              get '/api/addresses'
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            it "returns status 200" do
                get "/api/addresses" , params: { access_token: customer_user_token.token}
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            it "returns status 200" do
                get "/api/addresses" , params: { access_token: seller_user_token.token}
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /addresses#show" do
      
      
        context "when user is not authenticated" do
          it "returns status 401" do
            get '/api/addresses/41'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          it "returns status 200" do
            get "/api/addresses/#{customer_address.id}" , params: { access_token: customer_user_token.token }
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          it "returns status 200" do
            get "/api/addresses/#{seller_address.id}" , params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
    end

    
    describe "post /addresses#create" do

        context "when user is not authenticated" do
          it "returns status 401" do
            post '/api/addresses'
            expect(response).to have_http_status(401)
          end
        end
  
       
  
        context "when authenticated seller_user creates with invalid params" do
          it "return status 422" do
            post "/api/addresses/" , params: {access_token: seller_user_token.token , address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: nil, phone: nil, addressable:seller }}
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user create with valid params" do
          it "return status 201" do
            post "/api/addresses/" , params: {access_token: seller_user_token.token ,  address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: 641001, phone: 7654321899, addressable:seller }}
            expect(response).to have_http_status(201)
          end
  
        end

        context "when authenticated customer_user creates address with invalid params" do
            it "return status 422" do
              post"/api/addresses/" , params: {access_token: customer_user_token.token ,  address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: nil, phone: nil, addressable:customer }}
              expect(response).to have_http_status(422)
            end
    
          end
    
          context "when authenticated customer_user accesses creates address with valid params" do
            it "return status 201" do
              post "/api/addresses/" , params: {access_token: customer_user_token.token ,address:{door_no: '101',street:"East Street",district: "Coimbatore",state:"Tamil Nadu", pin_code: 641001, phone: 7654321899, addressable:customer }}
              expect(response).to have_http_status(201)
            end
    
          end
  
      end



    describe "patch /addresses#update" do

        context "when user is not authenticated" do
          it "returns status 401" do
            patch '/api/addresses/32'
            expect(response).to have_http_status(401)
          end
        end
  
       
  
        context "when authenticated seller_user accesses update with invalid params" do
          it "return status 422" do
            patch "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token , address:{pin_code: nil}}
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          it "return status 202" do
            patch "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token ,  address:{street: "Street A"}}
            expect(response).to have_http_status(202)
          end
  
        end

        context "when authenticated customer_user accesses update with invalid params" do
            it "return status 422" do
              patch "/api/addresses/#{customer_address.id}" , params: {access_token: customer_user_token.token , address:{pin_code: nil}}
              expect(response).to have_http_status(422)
            end
    
          end
    
          context "when authenticated customer_user accesses update with valid params" do
            it "return status 202" do
              patch "/api/addresses/#{customer_address.id}" , params: {access_token: customer_user_token.token ,  address:{street: "Street A"}}
              expect(response).to have_http_status(202)
            end
    
          end
  
      end


      describe "delete /addresses#destroy" do

        context "when user is not authenticated" do
          it "returns status 401" do
            delete '/api/addresses/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses delete" do
          it "return status code 200" do
            delete "/api/addresses/#{customer_address.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated customer_user accesses delete another customer Address" do
          it "return status 403" do
            delete "/api/addresses/#{customer_address.id + 1}" , params: {access_token: customer_user_token.token }
            expect(response).to have_http_status(403)
          end
  
        end
  
        context "when authenticated seller_user deleted address successfully " do
          it "return status 200" do
            delete "/api/addresses/#{seller_address.id}" , params: {access_token: seller_user_token.token }
            expect(response).to have_http_status(200)
          end
  
        end

        context "when authenticated seller_user accesses delete another seller Address" do
            it "return status 403" do
              delete "/api/addresses/#{seller_address.id + 1}" , params: {access_token: seller_user_token.token }
              expect(response).to have_http_status(403)
            end
    
        end

        context "when authenticated customer_user accesses delete another seller Address" do
            it "return status 403" do
              delete "/api/addresses/#{seller_address.id }" , params: {access_token: customer_user_token.token }
              expect(response).to have_http_status(403)
            end
    
        end

        context "when authenticated seller_user accesses delete another customer Address" do
            it "return status 403" do
              delete "/api/addresses/#{customer_address.id }" , params: {access_token: seller_user_token.token }
              expect(response).to have_http_status(403)
            end
    
        end
  
      end



      describe "put /addresses#primary_address" do
        context "when user is not authenticated" do
          it "returns status 401" do
            put '/api/addresses/primary_address'
            expect(response).to have_http_status(401)
          end
        end
        context "when authenticated seller_user accesses update with valid address" do
            it "return status 200" do
              put "/api/addresses/primary_address" , params: {access_token: seller_user_token.token ,  id:seller_address.id }
              expect(response).to have_http_status(200)
            end
    
          end

          context "when authenticated customer_user accesses update with valid address" do
            it "return status 200" do
              put "/api/addresses/primary_address" , params: {access_token: customer_user_token.token ,  id:customer_address.id }
              expect(response).to have_http_status(200)
            end
    
          end

          context "when authenticated customer_user accesses update with other's address" do
            it "return status 403" do
              put "/api/addresses/primary_address" , params: {access_token: customer_user_token.token ,  id:seller_address.id }
              expect(response).to have_http_status(403)
            end
    
          end

          context "when authenticated seller_user accesses update with other's address" do
            it "return status 403" do
              put "/api/addresses/primary_address" , params: {access_token: seller_user_token.token ,  id:customer_address.id }
              expect(response).to have_http_status(403)
            end
    
          end
  
      end
    
  


  



end
