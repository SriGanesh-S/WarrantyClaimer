require 'rails_helper'

RSpec.describe SellersController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:user_customer) {create(:user, :for_customers)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    describe 'GET Index' do
     context 'Not Logged in' do
        before do

             get :index
        end
        it 'render index' do
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when seller tries to access their profile' do
        before do
                 sign_in  user_seller
                 get :show, params:{id: seller.id}
        end
          it 'render show' do
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a profile of another seller' do
            before do
                   sign_in user_seller
                 get :show, params: { id: seller.id + 1  }
            end
            it 'redirect to root path' do
                expect(response).to redirect_to(root_path)
             end
        end

       

        context 'when seller tries to access a profile with random id ' do
            before do
                   sign_in user_seller
                 get :show, params: { id: 456 }
            end
            it 'redirect to root path' do
                expect(response).to redirect_to(root_path)
             end
        end

    end

    describe 'PATCH update' do
        context 'when seller updates profile with invalid parameters' do 
            before do
                   sign_in  user_seller
                 patch :update ,params: {seller:{name: '12345'}, id: seller.id }
            end
            it  'render edit' do
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates profile with valid parameters' do 
            before do
                   sign_in  user_seller
                 patch :update ,params: {seller:{age: 21}, id: seller.id}
            end
            it  'render Show path' do
                expect(response).to render_template :show
            end

        end

    end


    describe 'PUT edit' do
        context 'when user not signed in' do 
            before do

                 put :edit ,params: { id: seller.id }
            end
            it  'redirect to root path' do
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when user signed in as customer' do 
            before do
                   sign_in user_customer
                 put :edit ,params: { id: seller.id }
            end
            it  'redirect to root path' do
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when seller is signed in and edit his profile' do 
            before do
                   sign_in  user_seller
                 put :edit ,params: {id: seller.id}
            end
            it  'render edit page' do
                expect(response).to render_template :edit
            end

        end
        context 'when seller is signed in and try to edit others profile' do 
            before do
                   sign_in  user_seller
                 put :edit ,params: {id: seller.id  + 1}
            end
            it  'render root page' do
                expect(response).to redirect_to(root_path)
            end

        end

    end


    describe 'GET dashboard' do
        context 'when user not signed in' do 
            before do

                 get :dashboard 
            end
            it  'redirect to root path' do
                expect(response).to redirect_to(root_path)
            end

        end

        context 'when user signed in as customer' do 
            before do
                   sign_in user_customer
                 get :dashboard 
            end
            it  'redirect to root path' do
                
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when user signed in as seller' do 
            before do
                   sign_in  user_seller
                 get :dashboard
            end
            it  'render dashboard page' do
                expect(response).to render_template :dashboard
            end

        end
        
        

    end


      

end