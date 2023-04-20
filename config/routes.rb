Rails.application.routes.draw do
  resources :claim_statuses
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_pages#index'
  resources :customers
  resources :sellers
  resources :products
  resources :warranty_claims ,:claim_statuses ,:addresses


end
