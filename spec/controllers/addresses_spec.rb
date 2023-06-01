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
         before do 
            get :index
        end 
        it 'render Log in Page' do
             expect(response).to redirect_to(new_user_session_path)
        end
        
     end
     context 'Logged in as customer' do
        before do 
            sign_in user_customer
            get :index
        end 
        it 'render index' do
            expect(response).to render_template :index
       end
      end
     context 'Logged in as seller' do
        before do 
            sign_in user_seller
            get :index
        end 
        it 'render index' do
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when seller tries to access their Address' do
            before do 
                sign_in  user_seller
                get :show, params:{id: seller_address.id}
            end 
        it 'render show' do
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a address of another ' do
            before do 
                sign_in user_seller
                get :show, params: { id: customer_address.id   }
            end 
            it 'redirect to root path' do
                expect(response).to redirect_to(root_path)
             end
        end
        context 'when customer tries to access their Address' do
            before do 
                sign_in  user_customer
                get :show, params:{id: customer_address.id}
            end 
            it 'render show' do
              expect(response).to render_template :show
  
             end
        end
        context 'when customer tries to access others Address' do
            before do 
                sign_in  user_customer
                get :show, params:{id: seller_address.id}
            end 
            it 'render show' do
              expect(response).to  redirect_to(root_path)
  
             end
        end
       

        

    end

    describe 'PATCH update' do
        context 'when seller updates address with invalid parameters' do 
            before do 
                sign_in  user_seller
                patch :update ,params: {address:{pin_code: '12345'}, id: seller_address.id }
            end 
            it  'render edit' do
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates profile with valid parameters' do 
            before do 
                sign_in  user_seller
                patch :update ,params: {address:{street: "B street"}, id: seller_address.id}
            end 
            it  'render Show path' do
                expect(response).to redirect_to(change_primary_address_path)
            end

        end

        context 'when customer updates address with invalid parameters' do 
            before do 
                sign_in  user_customer
                patch :update ,params: {address:{pin_code: '12345'}, id: customer_address.id }
            end 
            it  'render edit' do
                expect(response).to render_template :edit
            end

        end
    
        context 'when customer updates profile with valid parameters' do 
            before do 
                sign_in  user_customer
                patch :update ,params: {address:{street: "B street"}, id: customer_address.id}
            end 
            it  'render Show path' do
                expect(response).to redirect_to(change_primary_address_path)
            end

        end

    end


    describe "Get New" do
        context "when user not signed_in" do
            before do 
                    get :new  
            end 
            it "redirect_to login page" do
                expect(response).to redirect_to(new_user_session_path)
            end
            
        end

        context "when user is seller" do
            before do 
                sign_in user_seller
                get :new 
            end 
            it "redirect to root" do
                expect(response).to render_template :new
            end

        end
        context "when user is customer" do
            before do 
                sign_in user_customer
                get :new 
            end 
            it "render new" do
                expect(response).to render_template :new
            end

        end

    end

    describe 'PUT edit' do
        context 'when user not signed in' do 
            before do  
                put :edit ,params: { id: customer_address.id }
            end 
            it  'redirect to root path' do
                expect(response).to redirect_to(new_user_session_path)
            end

        end

       
    
        context 'when seller is signed in and edit his address' do 
            before do 
                sign_in  user_seller
                put :edit ,params: {id: seller_address.id}
            end 
            it  'render edit page' do
                expect(response).to render_template :edit
            end

        end
        context 'when seller is signed in and try to edit others address' do 
            before do 
                sign_in  user_seller
                put :edit ,params: {id: customer_address.id  }
            end 
            it  'render root page' do
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when customer is signed in and edit his address' do 
            before do 
                sign_in  user_customer
                put :edit ,params: {id: customer_address.id}
            end 
            it  'render edit page' do
                expect(response).to render_template :edit
            end

        end
        context 'when customer is signed in and try to edit others address' do 
            before do 
                sign_in  user_customer
                put :edit ,params: {id: seller_address.id  }
            end 
            it  'render root page' do
                expect(response).to redirect_to(root_path)
            end

        end

    end


    describe "post Create" do

        context "when address is not valid" do
            before do 
                sign_in user_customer
                post :create , params:{address:{ pin_code:nil, street:"xyz"}} 
            end 
            it "render new" do
                expect(response).to render_template :new

            end
        end
        context "when claim is valid" do
            before do 
                sign_in user_seller
                post :create , params:{address:{door_no:'110', street:" 8th Street ", district: "Coimbatore",state:"Tamil Nadu", pin_code:641016, phone:7654321909  }} 
            end 
            it "render index " do
                expect(response).to render_template :show
            end

        end

    end


    describe "get primary_address" do

        context "when address is not valid" do
            before do 
                sign_in user_customer
                get :primary_address, params:{id: customer_address.id + 1} 
            end 
            it "render new" do
                expect(response).to redirect_to(root_path)

            end
        end
        context "when address is valid" do
            before do 
                sign_in user_customer
                get :primary_address  , params:{id: customer_address  } 
            end 
            it "render index " do
                expect(response).to redirect_to(change_primary_address_path)
            end

        end

    end


      

end