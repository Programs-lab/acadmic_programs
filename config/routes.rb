Rails.application.routes.draw do
  devise_for :users
  
  namespace :admin do
    resources :users # Have the admin manage them here.
  end
  root 'pages#home' 
  get 'pages/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
