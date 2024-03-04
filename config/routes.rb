Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "users/me", to: "users#me"
      post "/auth/login", to: "auth#login"
      post "/auth/register", to: "users#create"
      post "/auth/refresh", to: "auth#refresh_token"
      
      resources :folders, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        get "/folders", to: "users#get_all_folders"
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
