Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :login
        resources :signup
      end
      resources :posts
    end
  end
end
