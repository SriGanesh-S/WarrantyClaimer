require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:user_customer) {create(:user, :for_customers)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let!(:product){create(:product,seller: seller )}
    describe 'GET Index' do
     context 'Not Logged in' do
        before do 

            get :index
        end 
       it 'render Log in' do
            expect(response).to redirect_to(new_user_session_path)
        end
        
     end


     context 'Logged in as customer' do
            before do 
                sign_in user_customer
                get :index
            end 
             it 'redirect root' do
                expect(response).to redirect_to(root_path)
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
        context 'when seller tries to access their products' do
                before do 
                    sign_in  user_seller
                get :show, params:{id: product.id}
                end
                it 'render show' do
                     expect(response).to render_template :show

                end
        end

        context 'when seller tries to access a profile of another seller' do
                before do 
                    sign_in user_seller
                get :show, params: { id: product.id + 1  }
                end 
                 it 'redirect to root path' do
                     expect(response).to redirect_to(root_path)
                end
        end


        context 'when seller tries to access a product with random id ' do
                before do 
                    sign_in user_seller
                get :show, params: { id: 456 }
                end 
                 it 'redirect to root path' do
                    expect(response).to redirect_to(root_path)
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

        context "when user is customer" do
                before do 
                    sign_in user_customer
                    get :new 
                end 
                 it "redirect to root" do
                    expect(response).to redirect_to(root_path)
                end

        end
        context "when user is seller" do
                before do 
                    sign_in user_seller
                     get :new 
                end 
                 it "render new" do
                    expect(response).to render_template :new
                end

        end

    end

    describe "post Create" do

        context "when product is not valid" do
                before do 
                    sign_in user_seller
                    post :create , params:{product:{name: "product" ,category: nil, seller: seller }} 
                end 
                 it "render new" do
                    expect(response).to render_template :new

                 end
        end
        context "when product is valid" do
                before do 
                    sign_in user_seller
                    post :create , params:{product:{name: "Hp" ,category: "Laptop", seller: seller }} 
                end 
                 it "render index " do
                         expect(response).to redirect_to(products_path)
                 end

        end

    end


    describe 'PATCH update' do
        context 'when seller updates product with invalid parameters' do 
                before do 
                    sign_in  user_seller
                     patch :update ,params: {product:{name: nil}, id: product.id }
                end 
                 it  'render  Edit' do
                     expect(response).to render_template :edit
                 end

        end
    
        context 'when seller updates product with valid parameters' do 
                before do 
                    sign_in  user_seller
                patch :update ,params: {product:{name: "hp"}, id: product.id}
                end 
                 it  'render  Show ' do
                    expect(response).to render_template :show
                 end

        end

    end



    describe 'PUT edit' do
        context 'when user not signed in' do 
                before do 

                    put :edit ,params: { id: product.id }
                end 
                 it  'redirect to root path' do
                    expect(response).to redirect_to(new_user_session_path)
                 end

        end

        context 'when user signed in as customer' do 
                before do 
                    sign_in user_customer
                     put :edit ,params: { id: product.id }
                end 
                 it  'redirect to root path' do
                      expect(response).to redirect_to(root_path)
                 end

        end
    
        context 'when seller is signed in and edit his product' do 
                before do 
                    sign_in  user_seller
                put :edit ,params: {id: product.id}
                end 
                 it  'render edit page' do
                     expect(response).to render_template :edit
                 end

        end
        context 'when seller is signed in and try to edit other\'s products' do 
                before do 
                    sign_in  user_seller
                    put :edit ,params: {id:  product.id+1 }
                end 
                it  'render root page' do
                     expect(response).to redirect_to(root_path)
                end

        end

    end

   
      

end