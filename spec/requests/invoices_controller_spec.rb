require 'rails_helper'

RSpec.describe "Api::InvoicesControllers", type: :request do

    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}

    let!(:seller){create(:seller)}
    let!(:user_seller){create(:user,:for_sellers, userable: seller)}

    let!(:product){create(:product,seller: seller )} 
    let!(:invoice){create(:invoice, customer:customer , product:product)}

    let(:customer_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_customer.id)} 
    let(:seller_user_token) { create(:doorkeeper_access_token , resource_owner_id: user_seller.id)}
  

    describe "get /invoices#index" do
        
        context "when user is not authenticated" do
            it "returns status 401" do
              get '/api/invoices'
              expect(response).to have_http_status(401)
            end
          end

          context "when  customer user is authenticated" do
            it "returns status 200" do
                get "/api/invoices" , params: { access_token: customer_user_token.token}
                expect(response).to have_http_status(200)
            end
          end

          context "when seller user is authenticated" do
            it "returns status 200" do
                get "/api/invoices" , params: { access_token: seller_user_token.token}
                expect(response).to have_http_status(200)
            end
          end
    end

    describe "get /invoices#show" do
      
      
        context "when user is not authenticated" do
          it "returns status 401" do
            get '/api/invoices/41'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses show" do
          it "returns status 200" do
            get "/api/invoices/#{invoice.id}" , params: { access_token: customer_user_token.token }
            expect(response).to have_http_status(200)
          end
        end
  
        context "when authenticated seller_user accesses show" do
          it "returns status 200" do
            get "/api/invoices/#{invoice.id}" , params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(200)
          end
        end
    end


    describe "post /invoices#create" do
      context "when user is not authenticated" do
        it "returns status 401" do
          post '/api/invoices/'
          expect(response).to have_http_status(401)
        end
      end

      context "when authenticated customer_user accesses create" do
        it "return status code 403" do
          post "/api/invoices/" , params: { access_token: customer_user_token.token, invoice:{purchase_date:"2023-01-01", product_id:product.id , cust_email:"abc@gmail.com"}}
          expect(response).to have_http_status(403)
        end
      end

      context "when authenticated seller_user creates invoice with invalid params" do
        it "return status 422" do
          post "/api/invoices/" , params: {access_token: seller_user_token.token , invoice:{purchase_date:nil, product_id:product.id , cust_email:customer.email}}
          expect(response).to have_http_status(422)
        end
      end\

      context "when authenticated seller_user creates invoice with invalid customer" do
        it "return status 404" do
          post "/api/invoices/" , params: {access_token: seller_user_token.token , invoice:{purchase_date:"2023-01-01", product_id:product.id , cust_email:"abc@gmail.com"}}
          expect(response).to have_http_status(404)
        end

      end

      context "when authenticated seller_user accesses creates invoice with valid params" do
        it "return status 202" do
          post"/api/invoices/" , params: {access_token: seller_user_token.token ,   invoice:{purchase_date:"2023-04-02", product_id:product.id , cust_email:customer.email}}
          expect(response).to have_http_status(201)
        end

      end

    end

    
    describe "patch /invoices#update" do
        context "when user is not authenticated" do
          it "returns status 401" do
            patch '/api/invoices/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated customer_user accesses update" do
          it "return status code 403" do
            patch "/api/invoices/#{invoice.id}" , params: { access_token: customer_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated seller_user accesses update with invalid params" do
          it "return status 422" do
            patch "/api/invoices/#{invoice.id}" , params: {access_token: seller_user_token.token , invoice:{cust_email: nil}}
            expect(response).to have_http_status(422)
          end
  
        end
  
        context "when authenticated seller_user accesses update with valid params" do
          it "return status 202" do
            patch "/api/invoices/#{invoice.id}" , params: {access_token: seller_user_token.token ,  invoice:{puchase_date: "2022-04-02"}}
            expect(response).to have_http_status(202)
          end
  
        end
  
      end


      describe "delete /invoices#destroy" do

        context "when user is not authenticated" do
          it "returns status 401" do
            delete '/api/invoices/32'
            expect(response).to have_http_status(401)
          end
        end
  
        context "when authnticated seller_user accesses delete" do
          it "return status code 403" do
            delete "/api/invoices/#{invoice.id}" , params: { access_token: seller_user_token.token}
            expect(response).to have_http_status(403)
          end
        end
  
        context "when authenticated customer_user accesses delete another customer invoice" do
          it "return status 403" do
            delete "/api/invoices/#{invoice.id + 1}" , params: {access_token: customer_user_token.token }
            expect(response).to have_http_status(403)
          end
  
        end
  
        context "when authenticated customer_user deleted successfully " do
          it "return status 200" do
            delete "/api/invoices/#{invoice.id}" , params: {access_token: customer_user_token.token }
            expect(response).to have_http_status(200)
          end
  
        end
  
      end


   
  



end
