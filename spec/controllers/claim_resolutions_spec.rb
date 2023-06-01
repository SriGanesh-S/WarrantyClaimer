require 'rails_helper'

RSpec.describe ClaimResolutionsController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers, userable:customer)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let!(:product){create(:product,seller: seller )}
    let!(:invoice){create(:invoice, customer:customer , product:product)}
    let!(:warranty_claim){create(:warranty_claim,invoice: invoice)}
    let!(:claim_resolution){create(:claim_resolution, warranty_claim: warranty_claim)}
    describe 'GET Index' do
     context 'Not Logged in' do
        before  do 

              get :index
        end  
        it 'render Log in' do
             expect(response).to redirect_to(new_user_session_path)
        end
        
     end


     context 'Logged in as customer' do
        before  do 
              sign_in user_customer
              get :index
        end  
        it 'render index' do
            expect(response).to render_template :index
       end
        
     end
     context 'Logged in as seller' do
        before  do 
              sign_in user_seller
              get :index
        end  
        it 'render index' do
             expect(response).to render_template :index
        end
        
     end
    end
    

    describe 'GET Show' do
        context 'when seller tries to access claim resolutions for their products' do
            before  do 
                  sign_in  user_seller
                  get :show, params:{id: claim_resolution.id}
            end  
          it 'render show' do
            expect(response).to render_template :show

           end
        end

        context 'when seller tries to access a claim for  another seller\'s product ' do
            before  do 
                  sign_in user_seller
                  get :show, params: { id: claim_resolution.id + 1 }
            end  
            it 'redirect to root path' do
                expect(response).to redirect_to(root_path)
             end
        end

        context 'when customer tries to access  claim resolution for their products' do
            before  do 
                  sign_in  user_customer
                  get :show, params:{id: claim_resolution.id}
            end  
            it 'render show' do
              expect(response).to render_template :show
  
            end
        end
        context 'when customer tries to access a claim resolution for  another customer\'s product ' do
            before  do 
                  sign_in user_customer
                  get :show, params: { id: claim_resolution.id + 1 }
            end  
            it 'redirect to root path' do
                expect(response).to redirect_to(root_path)
             end
        end

      

    end
    describe "Get New" do
        context "when user not signed_in" do
            before  do 

                  get :new  
            end  
            it "redirect_to login page" do
                expect(response).to redirect_to(new_user_session_path)
            end
            
        end

        context "when user is customer" do
            before  do 
                  sign_in user_customer
                  get :new 
            end  
            it "redirect to root" do
                expect(response).to redirect_to(root_path)
            end

        end
        context "when user is seller" do
            before  do 
                  sign_in user_seller
                  get :new 
            end  
            it "render new" do
                expect(response).to render_template :new
            end

        end

    end

    describe "post Create" do

        context "when claim resolution is not valid" do
            before  do 
                  sign_in user_seller
                  post :create , params:{claim_resolution:{warranty_claim_id: claim_resolution.warranty_claim.id , status:"", description:"" }} 
            end  
            it "render new" do
                expect(response).to render_template :new

            end
        end
        context "when claim is valid" do
            before  do 
                  sign_in user_seller
                  post :create , params:{claim_resolution:{warranty_claim_id: warranty_claim.id , status:claim_resolution.status, description:claim_resolution.description }} 
            end  
            it "render index " do
                expect(response).to render_template :index
            end

        end

    end


    describe 'PATCH update' do
        context 'when seller updates claim resolution with invalid parameters' do 
            before  do 
                  sign_in  user_seller
                  patch :update , params:{claim_resolution:{ description: "",warranty_claim_id: warranty_claim.id  }, id: claim_resolution.id} 
            end  
            it  'render  Edit' do
                expect(response).to render_template :edit
            end

        end
    
        context 'when seller updates claim  with valid parameters' do 
            before  do 
                  sign_in  user_seller
                  patch :update , params:{claim_resolution:{ description: "This is the updated description ", status: "Accepted" }, id: claim_resolution.id} 
            end  
            it  'render  Show ' do
                expect(response).to redirect_to claim_resolution_url(claim_resolution)
            end

        end

    end



    describe 'PUT edit' do
        context 'when user not signed in' do 
            before  do 

                  put :edit ,params: { id: claim_resolution.id }
            end  
            it  'redirect to root path' do
                expect(response).to redirect_to(new_user_session_path)
            end

        end

        context 'when user signed in as customer' do 
            before  do 
                  sign_in user_customer
                  put :edit ,params: { id: claim_resolution.id }
            end  
            it  'redirect to root path' do
                expect(response).to redirect_to(root_path)
            end

        end
    
        context 'when seller is signed in and edit his claim resolutions' do 
            before  do 
                  sign_in  user_seller
                  put :edit ,params: {id: claim_resolution.id}
            end  
            it  'render edit page' do
                expect(response).to render_template :edit
            end

        end
        context 'when customer is signed in and try to edit other\'s claims' do 
            before  do 
                  sign_in  user_seller
                  put :edit ,params: {id:  claim_resolution.id+1 }
            end  
            it  'render root page' do
                expect(response).to redirect_to(root_path)
            end

        end

    end

   
      

end