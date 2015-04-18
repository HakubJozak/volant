Rails.application.routes.draw do

  namespace :v1 do
    resources :countries, only: [ :index ]
    resources :workcamp_intentions, only: [ :index ]
    resources :workcamps, only: [ :index, :show ] do
      get 'short', on: :collection
      get 'similar', on: :member
    end
    resources :apply_forms, only: [ :create ]
  end

  resources :workcamp_assignments, only: [ :index, :create, :update, :destroy, :show ]
  resources :email_contacts, only: [ :create, :update, :destroy ]
  resources :countries, except: [ :edit, :new ]
  resources :country_zones, except: [ :edit, :new ]
  resources :organizations, except: [ :edit, :new ]
  resources :networks, except: [ :edit, :new ]
  resources :workcamp_intentions, except: [ :edit, :new ]
  resources :volunteers, except: [ :edit, :new ]
  resources :tags, except: [ :edit, :new ]
  resources :payments, except: [ :edit, :new ]
  resources :attachments, except: [ :edit, :new ]
  resources :bookings, except: [ :edit, :new ]

  post '/workcamps/import', to: 'import#create'
  post '/workcamps/confirm_all', to: 'import#confirm_all'
  post '/workcamps/cancel_all', to: 'import#cancel_all'    

  resources :import_changes, except: [ :create ]

  resources :workcamps, except: [ :edit, :new ] do
    member do
      # Project Exchange Form - XML
      get :pef
      post :cancel_import
      post :confirm_import
    end
  end

  resources :stars, only: [ :create ]

  resources :apply_forms do
    member do
      post :cancel
      post :ask
      post :accept
      post :reject
      post :infosheet
      # Volunteer Exchange Form
      get :vef
    end
  end

  resources :messages do
    member do
      post :deliver
    end
  end

  resources :email_templates, except: [ :edit, :new ]

  get '/stats/:name', to: 'statistics#show'

  root 'dashboard#index'
  get 'dashboard/index'

  devise_for :users, path: 'accounts'

  # JSON API - not to clash with the above route ^
  resources :users
  resources :accounts, only: [ :index,:update, :show ]


end
