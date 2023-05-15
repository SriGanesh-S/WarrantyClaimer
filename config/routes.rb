Rails.application.routes.draw do
  devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  
    get "/customer/dashboard" , controller: :customers , action: :dashboard , as: :cust_dashboard
    get "/seller/dashboard" , controller: :sellers , action: :dashboard , as: :seller_dashboard
    get "/address/primary_address" , controller: :addresses , action: :primary_address , as: :primary_address
  resources :claim_statuses
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_pages#index'
  resources :customers
  resources :sellers
  resources :products
  resources :warranty_claims ,:claim_statuses ,:addresses


end
