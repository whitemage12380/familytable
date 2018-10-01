Rails.application.routes.draw do

  resources :ingredients
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  #get 'users', to: 'users/registrations#show'

  resources :families
  resources :family_members
  resources :family_dishes
  resources :ingredients

  root to: "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
