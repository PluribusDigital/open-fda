Rails.application.routes.draw do
  
  root 'home#index'

  # route to API docs
  get 'apidocs', to: redirect('/swagger/dist/index.html#!/default/')
  
  # namespace APIs w/ version
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :drugs, only:  [:index, :show]
      resources :events, only: [:index]
      get 'node/drug/:id', to:'node#drug'
    end
  end
  
end
