Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  
  namespace :admin do
    resources :users, path: 'usuarios' do 
      post '/invitar', to: 'users#invite', as: :invite
      post '/habilitar', to: 'users#enable', as: :enable
      post '/deshabilitar', to: 'users#disable', as: :disable
    end
  end
    resources :companies, path: 'empresas', only: [:index, :create, :update, :destroy]
  
  root 'pages#home' 
  get 'pages/home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
