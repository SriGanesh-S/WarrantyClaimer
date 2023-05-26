require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers,userable: customer)}
    let!(:user_seller){create(:user,:for_sellers)}
    describe 'GET Index' do
     context 'Not Logged in' do
        it 'render index' do
             get :index
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when customer tries to access their profile' do
          it 'render show' do
            sign_in  user_customer
            get :show, params:{id: user_customer.userable_id}
            expect(response).to render_template :show

           end
        end

        context 'when customer tries to access a profile of another customer' do
            it 'redirect to root path' do
                sign_in user_customer
                get :show, params: { id: customer.id+1 }
                expect(response).to redirect_to(root_path)
             end
        end

        context 'when customer tries to access a profile with random id ' do
            it 'redirect to root path' do
                sign_in user_customer
                get :show, params: { id: 3678 }
                expect(response).to redirect_to(root_path)
             end
        end

      

    end

    describe 'PATCH update' do
        context 'when customer updates profile with invalid parameters' do 
            it  'render edit ' do
                sign_in  user_customer
                patch :update ,params: {customer:{name: '12345'}, id: customer.id }
                expect(response).to render_template :edit
            end

        end
    
        context 'when customer updates profile with valid parameters' do 
            it  'render show ' do
                sign_in  user_customer
                patch :update ,params: {customer:{age: 14}, id: user_customer.userable.id}
                expect(response).to render_template :show
            end

        end

    end


    describe 'PUT edit' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                put :edit ,params: { id: customer.id }
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when user signed in as seller' do 
            it  'redirect to root path' do
                sign_in user_seller
                put :edit ,params: { id: customer.id }
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when customer is signed in and edit his profile' do 
            it  'render edit page' do
                sign_in  user_customer
                put :edit ,params: {id: user_customer.userable.id}
                expect(response).to render_template :edit
            end

        end
        context 'when customer is signed in and try to edit others profile' do 
            it  'render root page' do
                sign_in  user_customer
                put :edit ,params: {id: customer.id + 3}
                expect(response).to redirect_to(root_path)
            end

        end

    end


    describe 'GET dashboard' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                get :dashboard 
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when user signed in as seller' do 
            it  'redirect to root path' do
                sign_in user_seller
                get :dashboard 
                
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when user signed in as customer ' do 
            it  'render dashboard page' do
                sign_in  user_customer
                get :dashboard
                expect(response).to render_template :dashboard
            end

        end
        
        

    end


      

end