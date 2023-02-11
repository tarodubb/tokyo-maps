Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :wards, only: [:index] do
    resources :reviews, only: %I[index show new create edit update]
  end
  resources :reviews, only: [:delete]
end
