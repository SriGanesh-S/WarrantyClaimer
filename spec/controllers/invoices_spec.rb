require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
    let!(:seller){create(:seller)}
    let!(:customer){create(:customer)}
    let!(:user_customer) {create(:user, :for_customers, userable: customer)}
    let!(:user_seller){create(:user,:for_sellers , userable: seller )}
    let!(:product){create(:product,seller: seller )}
    let!(:invoice){create(:invoice, customer:customer , product:product)}
    
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

     
    

    # describe 'GET Show' do
    #     context 'when seller tries to access their products' do
    #       it 'render show' do
    #         sign_in  user_seller
    #         get :show, params:{id: product.id}
    #         expect(response).to render_template :show

    #        end
    #     end

    #     context 'when seller tries to access a profile of another seller' do
    #         it 'redirect to root path' do
    #             sign_in user_seller
    #             get :show, params: { id: product.id + 1  }
    #             expect(response).to redirect_to(root_path)
    #          end
    #     end


    #     context 'when seller tries to access a product with random id ' do
    #         it 'redirect to root path' do
    #             sign_in user_seller
    #             get :show, params: { id: 456 }
    #             expect(response).to redirect_to(root_path)
    #          end
    #     end

    # end
  

    describe "post generate" do

        context "when invoice is not valid" do
           context "when customer email is not valid " do
                it "Flash Message " do
                    sign_in user_seller
                    post :generate , params:{ invoice:{id:product.id,purchase_date: invoice.purchase_date,cust_email: "1asd@gamil.com",product:product,customer:customer }} 
                    expect(flash[:notice]).to match( /Enter valid Customer mail /)
                 end
            end

            context "when product is not valid" do
                it "render new " do
                   sign_in user_seller
                   post :generate , params:{ invoice:{id:product.id + 79,purchase_date: invoice.purchase_date,cust_email:customer.email,product:product,customer:customer }} 
                   expect(response).to render_template :new 
                end
   
             end
    
        end
        context "when invoice is valid" do
            it "redirect to seller dashboard" do
                sign_in user_seller
                post :generate , params:{ invoice:{id:product.id,purchase_date: invoice.purchase_date,cust_email:customer.email,product:product,customer:customer }} 
                expect(response).to redirect_to(seller_dashboard_path)
            end

        end

     end

end