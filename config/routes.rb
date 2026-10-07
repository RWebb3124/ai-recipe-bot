Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  root "chats#new"

  resources :chats, only: %i[index new create show] do
    resources :messages, only: :create
  end

  resources :recipes, only: :show do
    resource :saved_recipe, only: %i[create destroy]
  end

  resources :saved_recipes, only: %i[index update]

  resources :pantry_items, except: :show

  get "up" => "rails/health#show", as: :rails_health_check
end
