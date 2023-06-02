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
  

    describe "post generate" do

        context "when invoice is not valid" do
           context "when customer email is not valid " do
            before do
                sign_in user_seller
                 post :generate , params:{ invoice:{id:product.id,purchase_date: invoice.purchase_date,cust_email: "1asd@gamil.com",product:product,customer:customer }} 
            end 
                it "Flash Message " do
                    expect(flash[:notice]).to match( /Enter valid Customer mail /)
                 end
            end

            context "when product is not valid" do
                before do
                    sign_in user_seller
                     post :generate , params:{ invoice:{id:product.id + 79,purchase_date: invoice.purchase_date,cust_email:customer.email,product:product,customer:customer }} 
                end 
                it "render new " do
                   expect(response).to render_template :new 
                end
   
             end
    
        end
        context "when invoice is valid" do
            before do
                sign_in user_seller
                 post :generate , params:{ invoice:{id:product.id,purchase_date: invoice.purchase_date,cust_email:customer.email,product:product,customer:customer }} 
            end 
            it "redirect to seller dashboard" do
                expect(response).to redirect_to(seller_dashboard_path)
            end

        end

     end


    # # describe 'GET Show' do
    # #     context 'when seller tries to access their products' do
    # #         before do
    # sign_in  user_selle     r
    # #         get :show,end 
    #  params:{id: product.id}
    # #       it 'render show' do
    # #         expect(response).to render_template :show

    # #        end
    # #     end

    # #     context 'when seller tries to access a profile of another seller' do
    # #           before do
    #   sign_in user_seller       
    # #             get :show,end 
    #  params: { id: product.id + 1  }
    # #         it 'redirect to root path' do
    # #             expect(response).to redirect_to(root_path)
    # #          end
    # #     end


    # #     context 'when seller tries to access a product with random id ' do
    # #           before do
    #   sign_in user_seller       
    # #             get :show,end 
    #  params: { id: 456 }
    # #         it 'redirect to root path' do
    # #             expect(response).to redirect_to(root_path)
    # #          end
    # #     end

    # # end

end