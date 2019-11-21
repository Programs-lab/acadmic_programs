Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admin do
    resources :users, path: 'usuarios' do
      post '/invitar', to: 'users#invite', as: :invite
      post '/habilitar', to: 'users#enable', as: :enable
      post '/deshabilitar', to: 'users#disable', as: :disable
    end
      get  '/doctores', to: 'users#doctors', as: :doctors
      get  '/pacientes', to: 'users#patients', as: :patients
  end

  resources :faculties, path: 'facultades', only: [:index, :new, :edit, :create, :update, :destroy]
  root 'redirection#index'
  get 'pages/home'
  get 'pages/medical_record'
  get 'pages/schedule'
  get 'pages/appointment'
  get 'pages/schedule_appointment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
