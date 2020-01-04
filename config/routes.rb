Rails.application.routes.draw do
  resources :spaces
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'sync', to: 'sync#sync'
end
