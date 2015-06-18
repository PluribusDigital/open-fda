Rails.application.routes.draw do
  
  root 'home#index'

  # route to API docs
  get 'api', to: redirect('/swagger/dist/index.html')
  
  # namespace APIs w/ version
  namespace :api do
    namespace :v1 do
      resources :drugs, only:  [:index, :show]
      resources :events, only: [:index]
    end
  end
  
end
