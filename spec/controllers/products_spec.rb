require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:user_customer) {create(:user, :for_customers)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let!(:product){create(:product,seller: seller )}
    describe 'GET Index' do
     context 'Not Logged in' do
        it 'render Log in' do
             get :index
             expect(response).to redirect_to(new_user_session_path)
        end
        
     end


     context 'Logged in as customer' do
        it 'redirect root' do
            sign_in user_customer
             get :index
             expect(response).to redirect_to(root_path)
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
        context 'when seller tries to access their products' do
          it 'render show' do
            sign_in  user_seller
            get :show, params:{id: product.id}
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a profile of another seller' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: product.id + 1  }
                expect(response).to redirect_to(root_path)
             end
        end


        context 'when seller tries to access a product with random id ' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: 456 }
                expect(response).to redirect_to(root_path)
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

        context "when user is customer" do
            it "redirect to root" do
                sign_in user_customer
                get :new 
                expect(response).to redirect_to(root_path)
            end

        end
        context "when user is seller" do
            it "render new" do
                sign_in user_seller
                get :new 
                expect(response).to render_template :new
            end

        end

    end

    describe "post Create" do

        context "when product is not valid" do
            it "render new" do
                sign_in user_seller
                post :create , params:{product:{name: "product" ,category: nil, seller: seller }} 
                expect(response).to render_template :new

            end
        end
        context "when product is valid" do
            it "render index " do
                sign_in user_seller
                post :create , params:{product:{name: "Hp" ,category: "Laptop", seller: seller }} 
                expect(response).to render_template :index
            end

        end

    end


    describe 'PATCH update' do
        context 'when seller updates product with invalid parameters' do 
            it  'render  Edit' do
                sign_in  user_seller
                patch :update ,params: {product:{name: nil}, id: product.id }
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates product with valid parameters' do 
            it  'render  Show ' do
                sign_in  user_seller
                patch :update ,params: {product:{name: "hp"}, id: product.id}
                expect(response).to render_template :show
            end

        end

    end



    describe 'PUT edit' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                put :edit ,params: { id: product.id }
                expect(response).to redirect_to(new_user_session_path)
            end

        end

        context 'when user signed in as customer' do 
            it  'redirect to root path' do
                sign_in user_customer
                put :edit ,params: { id: product.id }
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when seller is signed in and edit his product' do 
            it  'render edit page' do
                sign_in  user_seller
                put :edit ,params: {id: product.id}
                expect(response).to render_template :edit
            end

        end
        context 'when seller is signed in and try to edit other\'s products' do 
            it  'render root page' do
                sign_in  user_seller
                put :edit ,params: {id:  product.id+1 }
                expect(response).to redirect_to(root_path)
            end

        end

    end

   
      

end