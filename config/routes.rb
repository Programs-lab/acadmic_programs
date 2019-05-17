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

  resources :medical_records, path: 'historial_medico'
  get "medical_records/patient_record/:patient_id(/:appointment_id)" , to: 'medical_records#medical_record', as: :patient_medical_record
  post "medical_records/create_medical_record" , to: 'medical_records#create', as: :create_medical_record

  resources :appointments, path: 'citas'
  namespace :api do
    get 'appointments/:doctor_id', to: 'appointments#fetch_appointment_data'
    get 'appointments/:id_number/:id_type', to: 'appointments#fetch_user'
    get 'appointments/horario/working_hours/:wh_id/', to: 'appointments#is_available_working_hour'
    post 'media/:id', to: 'media#create'
  end

  get 'appointments/schedule_appointment_no_user', to: 'appointments#schedule_appointment_no_user', as: :schedule_appointment_no_user
  post 'appointments/create_appointment', to: 'appointments#create_appointment', as: :create_appointment_user
  post 'appointments/update_appointment', to: 'appointments#update_appointment', as: :update_appointment_user
  get 'appointments/scheduled_appointments', to: 'appointments#scheduled_appointments', as: :scheduled_appointments

  root 'pages#home'
  get 'pages/home'
  get 'pages/medical_record'
  get 'pages/schedule'
  get 'pages/appointment'
  get 'pages/schedule_appointment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
