Rails.application.routes.draw do
  get 'api', to: redirect('/swagger/dist/index.html')
  root 'home#index'
  resources :drugs, only: [:index, :show]
end
