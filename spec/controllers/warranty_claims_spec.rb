require 'rails_helper'

RSpec.describe WarrantyClaimsController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers, userable:customer)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let!(:product){create(:product,seller: seller )}
    let!(:invoice){create(:invoice, customer:customer , product:product)}
    let!(:warranty_claim){create(:warranty_claim,invoice: invoice)}
    describe 'GET Index' do
     context 'Not Logged in' do
        it 'render Log in' do
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
        context 'when seller tries to access warranty claims for their products' do
          it 'render show' do
            sign_in  user_seller
            get :show, params:{id: warranty_claim.id}
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a claim for  another seller\'s product ' do
            it 'redirect to root path' do
                sign_in user_seller
                get :show, params: { id: warranty_claim.id + 1 }
                expect(response).to redirect_to(root_path)
             end
        end

        context 'when customer tries to access warranty claims for their products' do
            it 'render show' do
              sign_in  user_customer
              get :show, params:{id: warranty_claim.id}
              expect(response).to render_template :show
  
            end
        end
        context 'when customer tries to access a claim for  another customer\'s product ' do
            it 'redirect to root path' do
                sign_in user_customer
                get :show, params: { id: warranty_claim.id + 1 }
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

        context "when user is seller" do
            it "redirect to root" do
                sign_in user_seller
                get :new 
                expect(response).to redirect_to(root_path)
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

    describe "post Create" do

        context "when claim is not valid" do
            it "render new" do
                sign_in user_customer
                post :create , params:{warranty_claim:{id:invoice.id, problem_description: nil  , invoice: invoice }} 
                expect(response).to render_template :new

            end
        end
        context "when claim is valid" do
            it "render index " do
                sign_in user_seller
                post :create , params:{warranty_claim:{id:invoice.id, problem_description: warranty_claim.problem_description  , invoice: invoice }} 
                expect(response).to redirect_to(warranty_claims_path)
            end

        end

    end


    describe 'PATCH update' do
        context 'when customer updates claim with invalid parameters' do 
            it  'render  Edit' do
                sign_in  user_customer
                patch :update , params:{warranty_claim:{ problem_description: "" },id:warranty_claim.id } 
                expect(response).to render_template :edit
            end

        end
    
        context 'when customer updates claim  with valid parameters' do 
            it  'render  Show ' do
                sign_in  user_seller
                patch :update , params:{warranty_claim:{ problem_description: "This is the updated problem description " },id: warranty_claim.id} 
                expect(response).to render_template :show
            end

        end

    end



    describe 'PUT edit' do
        context 'when user not signed in' do 
            it  'redirect to root path' do
                put :edit ,params: { id: warranty_claim.id }
                expect(response).to redirect_to(new_user_session_path)
            end

        end

        context 'when user signed in as seller' do 
            it  'redirect to root path' do
                sign_in user_seller
                put :edit ,params: { id: warranty_claim.id }
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when customer is signed in and edit his claim' do 
            it  'render edit page' do
                sign_in  user_customer
                put :edit ,params: {id: warranty_claim.id}
                expect(response).to render_template :edit
            end

        end
        context 'when customer is signed in and try to edit other\'s claims' do 
            it  'render root page' do
                sign_in  user_customer
                put :edit ,params: {id:  warranty_claim.id+1 }
                expect(response).to redirect_to(root_path)
            end

        end

    end

   
      

end