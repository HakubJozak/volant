#Volant::Application.routes.draw do
  # root :to => 'outgoing/apply_forms#index'

  # match '/email_templates/howto' => 'email_templates#howto', :as => :email_templates_howto
  # match '/incoming/workcamps/export_alliance.xml' => 'incoming/workcamps#export_alliance_xml', :as => :alliance_in
  # match '/outgoing/workcamps/export_alliance.xml' => 'outgoing/workcamps#export_alliance_xml', :as => :alliance_out
  # match '/incoming/workcamps/friday_list_csv' => 'incoming/workcamps#friday_list_csv', :as => :friday_list, :format => 'csv'
  # match 'outgoing/apply_forms/export' => 'outgoing/apply_forms#export', :as => :outgoing_apply_forms_export, :format => 'csv'

  # match ':controller/:action' => '#index',
  #       :as => :auto_complete,
  #       :constraints => { :action => /auto_complete_(belongs_to_)?for_\S+/ },
  #       :via => get

  # resources :payments
  # resources :organizations
  # resources :networks
  # resources :email_templates
  # resources :tags
  # resources :users
  # resources :workcamp_intentions
  # resources :workcamp_assignments
  # resources :countries
  # resources :languages
  # resources :infosheets
  # resources :countries
  # resources :apply_forms
  # resources :workcamp_intentions

  # resources :import_changes do
  #   member do
  #     post :apply
  #   end
  # end

  # resources :workcamps do
  #   collection do
  #     get :total
  #   end
  # end

  # resource :session
  # match '/login' => 'sessions#new', :as => :login
  # match '/logout' => 'sessions#destroy', :as => :logout
  # match '/apply_forms/accept/:id?_method=get' => 'apply_forms#accept', :as => :accept, :via => get, :_method => 'get', :parent_controller => 'apply_forms'

  # namespace :public do
  #   resources :workcamps
  # end

  # namespace :outgoing do
  #   resources :volunteers
  #   resources :apply_forms
  #   resources :apply_forms_special
  #   resources :workcamps

  #   resources :imported_workcamps do
  #     collection do
  #       post :confirm
  #       post :confirm_all
  #       post :cancel_all
  #     end
  #   end

  #   resources :updated_workcamps do
  #     collection do
  #       post :confirm
  #       post :confirm_all
  #       post :cancel_all
  #     end


  #   end
  #   resources :imports
  # end

  # namespace :incoming do
  #   resources :preparation_workcamps
  #   resources :season_workcamps
  #   resources :leaders
  #   resources :participations
  #   resources :participants
  #   resources :partners
  #   resources :hosting
  #   resources :bookings
  # end

  # match '/:controller(/:action(/:id))'
  # match ':controller/:action.:format' => '#index'
  # match '/incoming/:controller/:action/:id' => '#index'
  # match '/incoming/:controller/:action.:format' => '#index'
  # match '/incoming/:controller/:action/:id.:format' => '#index'
  # match '/outgoing/:controller/:action/:id' => '#index'
  # match '/outgoing/:controller/:action.:format' => '#index'
  # match '/outgoing/:controller/:action/:id.:format' => '#index'
#end
