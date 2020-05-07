Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api do
    get 'academic_programs/fetch_academic_programs/:faculty_id/', to: 'academic_programs#fetch_academic_programs'
    post 'media/:id', to: 'media#create'
    get  'procedure_documents/:id', to: 'procedure_documents#fetch'
    post  'procedure_documents/update/:id', to: 'procedure_documents#update'
    put  'procedure_documents/remove/:id', to: 'procedure_documents#remove_file'
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
      resources :process_academic_programs, path: "procesos", except: [:show] do
        resources :procedures, path: "tramites" do
          get '/diligenciar_documentos', to: 'procedures#procedure_documents', as: :procedure_documents
          post '/cerrar', to: 'procedures#close_procedure', as: :close
          post '/completar', to: 'procedures#complete_procedure', as: :complete
        end
      end
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
