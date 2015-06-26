Rails.application.routes.draw do
  
  root 'home#index'

  # route to API docs
  get 'apidocs', to: redirect('/swagger/dist/index.html#!/default/')
  
  # namespace APIs w/ version
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :drugs, only:  [:index, :show]
      resources :events, only: [:index]
      get 'node/drug/:product_ndc', to:'node#drug'
      get 'node/substance/:substance_name', to:'node#substance'
      get 'node/manufacturer/:manufacturer_name', to:'node#manufacturer'
    end
  end
  
end
