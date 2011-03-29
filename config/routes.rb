ActionController::Routing::Routes.draw do |map|
  # TODO - make dashboard
  map.root :controller => 'outgoing/apply_forms'

  map.email_templates_howto '/email_templates/howto', :controller => 'email_templates', :action => 'howto'
  map.alliance_in  '/incoming/workcamps/export_alliance.xml', :controller => 'incoming/workcamps', :action => 'export_alliance_xml'
  map.alliance_out '/outgoing/workcamps/export_alliance.xml', :controller => 'outgoing/workcamps', :action => 'export_alliance_xml'
  map.friday_list  '/incoming/workcamps/friday_list_csv', :controller => 'incoming/workcamps', :action => 'friday_list_csv', :format => 'csv'
  map.outgoing_apply_forms_export 'outgoing/apply_forms/export', :controller => 'outgoing/apply_forms', :action => 'export', :format => 'csv'

  # AdHoc fix - do it better?
  map.auto_complete ':controller/:action',
                  :requirements => { :action => /auto_complete_(belongs_to_)?for_\S+/ },
                  :conditions => { :method => :get }

  map.resources :payments, :active_scaffold => true
  map.resources :organizations, :active_scaffold => true
  map.resources :networks, :active_scaffold => true
  map.resources :email_templates, :active_scaffold => true
  map.resources :tags, :active_scaffold => true
  map.resources :users, :active_scaffold => true
  map.resources :workcamp_intentions, :active_scaffold => true
  map.resources :workcamp_assignments, :active_scaffold => true
  map.resources :countries, :active_scaffold => true
  map.resources :languages, :active_scaffold => true
  map.resources :infosheets, :active_scaffold => true
  map.resources :import_changes, :active_scaffold => true, :member => {  :apply => :post }
  #TODO - remove this REST API
   map.resources :countries,
                 :controller => 'RestfulCountries',
                 :path_prefix => '/rest',
                 :only => [ :index, :show ]

   map.resources :apply_forms,
                 :controller => 'RestfulApplyForms',
                 :path_prefix => '/rest',
                 :only => [ :create, :show ]

   map.resources :workcamp_intentions,
                 :controller => 'RestfulWorkcampIntentions',
                 :path_prefix => '/rest',
                 :only => [ :index, :show ]

   map.resources :workcamps,
                 :controller => 'RestfulWorkcamps',
                 :only => [ :index, :show ],
                 :has_one => :country,
                 :path_prefix => '/rest',
                 :has_one => :workcamp_intention,
                 :collection => {  :total => :get }

  map.resource :session
  map.login  "/login", :controller => 'sessions', :action => 'new'
  map.logout "/logout", :controller => 'sessions', :action => 'destroy'

  # TODO - should be post
  # Active Scaffold link to change the apply form state
  map.accept '/apply_forms/accept/:id?_method=get', :controller => 'apply_forms', :action => 'accept',
                        :_method => 'get',
                        :parent_controller => 'apply_forms',
                        :conditions => { :method => :get }

  map.namespace :public do |p|
    p.resources :workcamps, :only => [ :index, :show ]
  end

  map.namespace :outgoing do |o|
    o.resources :volunteers, :active_scaffold => true
    o.resources :apply_forms, :controller => :apply_forms, :active_scaffold => true
    o.resources :apply_forms_special, :active_scaffold => true
    o.resources :workcamps, :active_scaffold => true

    o.resources :imported_workcamps, :active_scaffold => true,
                :collection => { :confirm_all => :post, :cancel_all => :post, :confirm => :post }

    o.resources :updated_workcamps, :active_scaffold => true,
                :collection => { :confirm_all => :post, :cancel_all => :post, :confirm => :post }

    o.resources :imports, :only => [ :new, :create, :show ], :active_scaffold => false
  end

  map.namespace :incoming do |o|
    o.resources :preparation_workcamps, :active_scaffold => true
    o.resources :season_workcamps, :active_scaffold => true

    # o.resources :workcamps, :as => 'wc_with_partners', :controller => 'incoming/workcamps_with_partners', :active_scaffold => true
    o.resources :leaders, :active_scaffold => true
    o.resources :participations, :active_scaffold => true
    o.resources :participants, :active_scaffold => true
    o.resources :partners, :active_scaffold => true
    o.resources :hosting, :active_scaffold => true
    o.resources :bookings, :active_scaffold => true
  end


  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'

  # TODO - possible to remove somehow? - ActiveScaffold cannot find it without these routes
  map.connect '/incoming/:controller/:action/:id'
  map.connect '/incoming/:controller/:action.:format'
  map.connect '/incoming/:controller/:action/:id.:format'
  map.connect '/outgoing/:controller/:action/:id'
  map.connect '/outgoing/:controller/:action.:format'
  map.connect '/outgoing/:controller/:action/:id.:format'
end
