Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  resources :messages
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :login
        resources :signup
      end
      resources :posts
      get '/user_posts', to: 'posts#user_posts'
      resources :chats
      resources :messages
      resources :comments
    end
  end
end
