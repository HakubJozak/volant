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

  post '/workcamps/import', to: 'import#create'
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


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
