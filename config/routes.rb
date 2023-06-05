Rails.application.routes.draw do
  use_doorkeeper
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
    
    get "/customer/dashboard" , controller: :customers , action: :dashboard , as: :cust_dashboard
    get "/seller/dashboard" , controller: :sellers , action: :dashboard , as: :seller_dashboard
    post "/invoice/generate" , controller: :invoices , action: :generate , as: :generate_invoice
    get "/address/primary_address" , controller: :addresses , action: :primary_address , as: :primary_address
    get "/address/change_primary_address" , controller: :addresses , action: :change_primary_address , as: :change_primary_address
    patch "/claim_resolutions", controller: :claim_resolutions , action: :update 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_pages#index'
  resources :customers
  resources :sellers
  resources :products
  resources :invoices
  resources :warranty_claims ,:addresses
  resources :claim_resolutions


  namespace :api , default: {format: :json} do
    devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
    
    get "/customers/customer_invoices" , controller: :customers , action: :customer_invoices , as: :cutomer_invoices
    get "/sellers/seller_products" , controller: :sellers , action: :seller_products , as: :seller_products
    get "/sellers/stats" , controller: :sellers , action: :stats , as: :stats
    post "/invoice/generate" , controller: :invoices , action: :generate , as: :generate_invoice
    patch "/addresses/primary_address" , controller: :addresses , action: :primary_address , as: :primary_address
    get "/address/change_primary_address" , controller: :addresses , action: :change_primary_address , as: :change_primary_address
    patch "/claim_resolutions/default_claim_resolution" ,controller: :claim_resolutions,action: :default_claim_resolution,as: :default_claim_resolution
 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_pages#index'
  resources :customers
  resources :sellers
  resources :products
  resources :invoices
  resources :warranty_claims  ,:addresses
  resources :claim_resolutions
  end


end
