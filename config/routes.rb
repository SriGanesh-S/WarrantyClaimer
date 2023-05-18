Rails.application.routes.draw do
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
  resources :claim_resolutions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_pages#index'
  resources :customers
  resources :sellers
  resources :products
  resources :invoices
  resources :warranty_claims ,:claim_statuses ,:addresses


end
