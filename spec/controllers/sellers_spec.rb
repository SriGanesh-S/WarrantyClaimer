require 'rails_helper'

RSpec.describe SellersController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:user_customer) {create(:user, :for_customers)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    describe 'GET Index' do
     context 'Not Logged in' do
        it 'render index' do
             get :index
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when seller tries to access their profile' do
          it 'render show' do
            sign_in  user_seller
            get :show, params:{id: seller.id}
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a profile of another seller' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: seller.id + 1  }
                expect(response).to redirect_to(root_path)
             end
        end

       

        context 'when seller tries to access a profile with random id ' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: 456 }
                expect(response).to redirect_to(root_path)
             end
        end

    end

    describe 'PATCH update' do
        context 'when seller updates profile with invalid parameters' do 
            it  'render edit' do
                sign_in  user_seller
                patch :update ,params: {seller:{name: '12345'}, id: seller.id }
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates profile with valid parameters' do 
            it  'render Show path' do
                sign_in  user_seller
                patch :update ,params: {seller:{age: 21}, id: seller.id}
                expect(response).to render_template :show
            end

        end

    end


    describe 'PUT edit' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                put :edit ,params: { id: seller.id }
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when user signed in as customer' do 
            it  'redirect to root path' do
                sign_in user_customer
                put :edit ,params: { id: seller.id }
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when seller is signed in and edit his profile' do 
            it  'render edit page' do
                sign_in  user_seller
                put :edit ,params: {id: seller.id}
                expect(response).to render_template :edit
            end

        end
        context 'when seller is signed in and try to edit others profile' do 
            it  'render root page' do
                sign_in  user_seller
                put :edit ,params: {id: seller.id  + 1}
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

        context 'when user signed in as customer' do 
            it  'redirect to root path' do
                sign_in user_customer
                get :dashboard 
                
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when user signed in as seller' do 
            it  'render dashboard page' do
                sign_in  user_seller
                get :dashboard
                expect(response).to render_template :dashboard
            end

        end
        
        

    end


      

end