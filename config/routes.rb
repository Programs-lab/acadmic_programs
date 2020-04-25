Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api do
    get 'academic_programs/fetch_academic_programs/:faculty_id/', to: 'academic_programs#fetch_academic_programs'
    post 'media/:id', to: 'media#create'
    get  'media/:id', to: 'media#index'
    delete  'media/:id', to: 'media#destroy'
  end

  namespace :admin do
    resources :users, path: 'usuarios' do
      post '/invitar', to: 'users#invite', as: :invite
      post '/habilitar', to: 'users#enable', as: :enable
      post '/deshabilitar', to: 'users#disable', as: :disable
    end
      get  '/doctores', to: 'users#doctors', as: :doctors
      get  '/pacientes', to: 'users#patients', as: :patients
  end

  resources :faculties, path: 'facultades', only: [:index, :new, :edit, :create, :update, :destroy] do
    resources :academic_departments, path: 'departamentos', except: [:show]
    resources :academic_programs, path: 'programas', except: [:show] do
      resources :process_academic_programs, path: "procesos", except: [:show]
    end
  end
  resources :academic_processes, path: 'procesos', only: [:index, :new, :edit, :create, :update, :destroy] do
    get '/documentos', to: 'academic_processes#documents', as: :documents
  end
  root 'redirection#index'
  get 'pages/home'
  get 'pages/medical_record'
  get 'pages/schedule'
  get 'pages/appointment'
  get 'pages/schedule_appointment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
