Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  
  namespace :admin do
    resources :users do 
      post '/invitar', to: 'users#invite', as: :invite
      post '/habilitar', to: 'users#enable', as: :enable
      post '/deshabilitar', to: 'users#disable', as: :disable
    end
  end
  
  root 'pages#home' 
  get 'pages/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
