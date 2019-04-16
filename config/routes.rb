Rails.application.routes.draw do
  get 'users/index'
  devise_for :users
  
  namespace :admin do
    resources :users, path: 'usuarios' do
      post '/invitar', to: 'users#invite', as: :invite
      post '/habilitar', to: 'users#enable', as: :enable
      post '/deshabilitar', to: 'users#disable', as: :disable
    end
      get  '/doctores', to: 'users#doctors', as: :doctors
      get  '/pacientes', to: 'users#patients', as: :patients
  end
  
  resources :companies, path: 'empresas', only: [:index, :create, :update, :destroy]
  get 'companies/procedure_companies_update', to: 'companies#update_procedure_companies'
  resources :procedure_types, path: 'tipos_de_estudio', only: [:index, :create, :update, :destroy]
  resources :working_weeks, path: 'horarios', only: [:index, :create, :update]
  resources :working_days, only: [:update]
  
  root 'admin/users#index' 
  get 'pages/home'
  get 'pages/medical_record'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
