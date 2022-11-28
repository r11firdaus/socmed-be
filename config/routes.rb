Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        resources :login
        resources :signup
      end
    end
  end
end
