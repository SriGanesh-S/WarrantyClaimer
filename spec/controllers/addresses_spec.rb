require 'rails_helper'

RSpec.describe AddressesController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers, userable:customer)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let! (:seller_address){create(:address,:for_sellers , addressable: seller )}
    let! (:customer_address){create(:address,:for_customers , addressable: customer )}


    describe 'GET Index' do
     context 'Not Logged in' do
        it 'render Log in Page' do
             get :index
             expect(response).to redirect_to(new_user_session_path)
        end
        
     end
     context 'Logged in as customer' do
        it 'render index' do
            sign_in user_customer
            get :index
            expect(response).to render_template :index
       end
      end
     context 'Logged in as seller' do
        it 'render index' do
             sign_in user_seller
             get :index
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when seller tries to access their Address' do
          it 'render show' do
            sign_in  user_seller
            get :show, params:{id: seller_address.id}
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a address of another ' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: customer_address.id   }
                expect(response).to redirect_to(root_path)
             end
        end
        context 'when customer tries to access their Address' do
            it 'render show' do
              sign_in  user_customer
              get :show, params:{id: customer_address.id}
              expect(response).to render_template :show
  
             end
        end
        context 'when customer tries to access others Address' do
            it 'render show' do
              sign_in  user_customer
              get :show, params:{id: seller_address.id}
              expect(response).to  redirect_to(root_path)
  
             end
        end
       

        

    end

    describe 'PATCH update' do
        context 'when seller updates address with invalid parameters' do 
            it  'render edit' do
                sign_in  user_seller
                patch :update ,params: {address:{pin_code: '12345'}, id: seller_address.id }
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates profile with valid parameters' do 
            it  'render Show path' do
                sign_in  user_seller
                patch :update ,params: {address:{street: "B street"}, id: seller_address.id}
                expect(response).to redirect_to(address_url(seller_address))
            end

        end

        context 'when customer updates address with invalid parameters' do 
            it  'render edit' do
                sign_in  user_customer
                patch :update ,params: {address:{pin_code: '12345'}, id: customer_address.id }
                expect(response).to render_template :edit
            end

        end
    
        context 'when customer updates profile with valid parameters' do 
            it  'render Show path' do
                sign_in  user_customer
                patch :update ,params: {address:{street: "B street"}, id: customer_address.id}
                expect(response).to redirect_to(address_url(customer_address))
            end

        end

    end


    describe "Get New" do
        context "when user not signed_in" do
            it "redirect_to login page" do
                get :new  
                expect(response).to redirect_to(new_user_session_path)
            end
            
        end

        context "when user is seller" do
            it "redirect to root" do
                sign_in user_seller
                get :new 
                expect(response).to render_template :new
            end

        end
        context "when user is customer" do
            it "render new" do
                sign_in user_customer
                get :new 
                expect(response).to render_template :new
            end

        end

    end

    describe 'PUT edit' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                put :edit ,params: { id: customer_address.id }
                expect(response).to redirect_to(new_user_session_path)
            end

        end

       
    
        context 'when seller is signed in and edit his address' do 
            it  'render edit page' do
                sign_in  user_seller
                put :edit ,params: {id: seller_address.id}
                expect(response).to render_template :edit
            end

        end
        context 'when seller is signed in and try to edit others address' do 
            it  'render root page' do
                sign_in  user_seller
                put :edit ,params: {id: customer_address.id  }
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when customer is signed in and edit his address' do 
            it  'render edit page' do
                sign_in  user_customer
                put :edit ,params: {id: customer_address.id}
                expect(response).to render_template :edit
            end

        end
        context 'when customer is signed in and try to edit others address' do 
            it  'render root page' do
                sign_in  user_customer
                put :edit ,params: {id: seller_address.id  }
                expect(response).to redirect_to(root_path)
            end

        end

    end


    describe "post Create" do

        context "when address is not valid" do
            it "render new" do
                sign_in user_customer
                post :create , params:{address:{ pin_code:nil, street:"xyz"}} 
                expect(response).to render_template :new

            end
        end
        context "when claim is valid" do
            it "render index " do
                sign_in user_seller
                post :create , params:{address:{door_no:'110', street:" 8th Street ", district: "Coimbatore",state:"Tamil Nadu", pin_code:641016, phone:7654321909  }} 
                expect(response).to render_template :show
            end

        end

    end


    describe "get primary_address" do

        context "when address is not valid" do
            it "render new" do
                sign_in user_customer
                get :primary_address, params:{id: customer_address.id + 1} 
                expect(response).to redirect_to(root_path)

            end
        end
        context "when claim is valid" do
            it "render index " do
                sign_in user_customer
                get :primary_address  , params:{id: customer_address  } 
                expect(response).to redirect_to(cust_dashboard_path)
            end

        end

    end


      

end