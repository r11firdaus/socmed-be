Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :login
        resources :signup
      end
      resources :posts
      get '/user_posts', to: 'posts#user_posts'
    end
  end
end
