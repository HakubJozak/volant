require 'yaml'
require "#{RAILS_ROOT}/vendor/plugins/active_scaffold/lib/paginator"
require "#{RAILS_ROOT}/app/models/outgoing/workcamp_assignment"
require "#{RAILS_ROOT}/app/models/outgoing/workcamp"

module Outgoing
  class ApplyFormsController < FilteringController
    helper 'outgoing/workcamps', :vef, :attachment

    cache_sweeper :menu_sweeper
    before_filter :reset_filter, :year_filter, :tag_filter, :adjust_title

    active_scaffold 'Outgoing::ApplyForm' do |config|
      # config.actions.add :list_filter
      # config.list_filter.add(:association, :volunteer, {:lastname => 'lastname'})

      config.columns = [ :volunteer,
                         :fee,
                         :cancelled,
                         :general_remarks,
                         :motivation,
                         :taggings,
                         :current_workcamp,
                         :current_workcamp_places,
                         :current_workcamp_places_for_males,
                         :current_workcamp_places_for_females,
                         :payment,
                         :workcamp_tags,
                         :volunteer_tags,
                         :actions
                       ]


      config.list.columns = [ :alerts,
                              :created_at,

                              :volunteer_tags,
                              :volunteer,
                              :volunteer_age,

                              :workcamp_tags,
                              :current_workcamp,
                              :current_workcamp_places,
                              :current_workcamp_places_for_males,
                              :current_workcamp_places_for_females,

                              :state,
                              :payment,
                              :actions
                            ]

      config.nested.add_link help.icon('workcamps', ApplyForm.human_attribute_name('workcamps')), [ :workcamp_assignments ]

      config.action_links.add :vef,
      :label => help.icon('vef', 'VEF'),
      :popup => true,
      :type => :record,
      :method => :get,
      :position => :replace,
      :inline => false

      config.action_links.add :export,
      :label => help.icon('export'),
      :popup => false,
      :type => :table,
      :method => :get,
      :inline => false

      config.action_links.add :cancel,
      :label => help.icon('cancel'),
      :type => :record,
      :confirm => ApplyForm.human_attribute_name("apply_form_actions.cancel_confirm"),
      :method => :post,
      :position => :replace,
      :inline => false

      config.search.columns = [ :volunteer, :current_workcamp, :payment, :general_remarks, :motivation ]


      config.nested.add_link help.icon('workcamps'), [ :workcamp_assignments ]
      config.columns[:volunteer].search_sql = Volunteer.sql_for_name_search
      config.columns[:volunteer].sort_by :sql => "#{Volunteer.table_name}.lastname"
      config.columns[:current_workcamp].search_sql = "(#{Workcamp.table_name}.code || ' ' || #{Workcamp.table_name}.name)"
      config.columns[:current_workcamp].sort_by :sql => "#{Workcamp.table_name}.code, #{Workcamp.table_name}.name"
      config.columns[:payment].search_sql = "payments.account"
      config.columns[:workcamp_tags].label = help.icon('workcamp_tags', ApplyForm.human_attribute_name('workcamp_tags'), true)
      config.columns[:volunteer_tags].label = help.icon('volunteer_tags', ApplyForm.human_attribute_name('volunteer_tags'), true)
      config.columns[:actions].label = help.icon('actions', nil, true)
      config.columns[:tags].clear_link

      setup_places_fields(config, 'current_workcamp_')
      ban_editing(config,
                  :actions,
                  :current_workcamp,
                  :volunteer_age,
                  :payment,
                  :workcamp_tags,
                  :volunteer_tags,
                  :current_workcamp_places,
                  :current_workcamp_places_for_males,
                  :current_workcamp_places_for_females)

      config.list.per_page = 10
      config.list.sorting = [ 'created_at' ]
      config.list.count_includes = false

      highlight_required(config, ApplyForm)
    end

    def find_page(options = {})
      # Hack, is there a better way?
      constraints = if 'Outgoing::Workcamp' == params[:parent_model].to_s
                      wc_id = active_scaffold_session_storage[:constraints][:workcamp_assignments][:workcamp]
                      wc = Outgoing::Workcamp.find(wc_id)
                      ids = wc.workcamp_assignments.map { |a| a.apply_form_id }.compact.join(',')
                      "#{ApplyForm.table_name}.id in (#{ids})"
                    else
                      conditions_from_constraints
                    end

      includes = [ :current_workcamp, :current_assignment, :volunteer, :payment, :taggings ]

      conditions = ApplyForm.merge_conditions( constraints,
                                               active_scaffold_conditions,
                                               all_conditions, # search conditions
                                               [ @filter_sql ].concat(@filter_params),
                                               ApplyForm.state_filter(params[:state_filter])
                                               )

      count = ApplyForm.count(:include => includes, :conditions => conditions)

      pager = ::Paginator.new(count, options[:per_page]) do |offset, per_page|
        ApplyForm.find(:all,
                       :offset => offset,
                       :limit => per_page,
                       :include => includes,
                       :conditions => conditions,
                       :order => options[:sorting].try(:clause)
                       )
      end

      pager.page(options[:page])
    end

    def vef
      @form = ApplyForm.find(params[:id])
      render :layout => false
    end

    # TODO - let it be AJAX request
    def cancel
      @record = ApplyForm.find(params[:id])

      unless @record.cancelled?
        @record.cancel.save
        flash[:info] = I18n.translate('model.apply_form_actions.cancel_success')
      else
        flash[:info] = I18n.translate('model.apply_form_actions.already_cancelled')
      end

      #render :partial => 'list_record', :object => @record, :layout => false
      #render :action => 'update.rjs', :layout => false
      redirect_to :back
    end


      # Reject application. Performs normal state transition
      # if current workcamp is last on the application, otherwise
      # just adjusts state of the form and notify the user.
      def reject
        @form = ApplyForm.find(params[:id])

        wc = @form.current_workcamp

        if @form.current_workcamp == @form.last_workcamp
          flash[:info] = ApplyForm.human_attribute_name('apply_form_actions.rejected_final', :wc => "#{wc.code} - #{wc.name}")
          state_transition :reject
        else
          # reject and ask for the next workcamp
          @form.reject
          flash[:info] = ApplyForm.human_attribute_name('apply_form_actions.rejected', :wc => "#{wc.code} - #{wc.name}")
          state_transition :ask
        end
      end

      def ask
        state_transition :ask do |form|
          wc = form.current_workcamp
          no_places_warning(wc, form.volunteer)
        end
      end

      def accept
        state_transition :accept
      end

      def infosheet
        state_transition :infosheet
      end

      protected

      def no_places_warning(wc, volunteer)
        if wc.full?(volunteer)
          flash[:warning] = ApplyForm.human_attribute_name('apply_form_actions.full_warning')
        elsif wc.almost_full?(volunteer)
          flash[:warning] = ApplyForm.human_attribute_name('apply_form_actions.almost_full_warning')
        end
      end


      # Opens mailing dialog or sends the filled out email, then changes
      # state of the apply form. Used as a generic response for ask, accept
      # and infosheet methods
      def state_transition(action)
        @action = action
        @form = ApplyForm.find(params[:id])

        if params[:mail]
          unless params[:confirm_not_send]
            begin
              @mail = ApplyFormMail.new(params)
              @mail.deliver
              @form.send(@action)
              flash[:info] = I18n.translate("emails.success")
            rescue ApplyFormMail::DeliveryFailure => error
              flash[:error] = I18n.translate("emails.failure") + ' Chyba: ' + error.message
            end
          else
            @form.send(@action)
            flash[:info] = ApplyForm.human_attribute_name("apply_form_states.changed")
          end

          redirect_to url_for(:action => 'index', :year => params[:year],
                              :state_filter => params[:state_filter],
                              :tag_id => params[:tag_id])
        else
          yield(@form) if block_given?
          @mail = ApplyFormMail.new(:action => @action,
                                    :form => @form,
                                    :user => current_user)
          render :partial => 'outgoing/apply_forms/mail'
        end
      end

      public

      # CSV file with current used filter
      def export
        name = ApplyForm.human_name(:count => 2)
        render_csv(Export::Csv::outgoing_apply_forms(:year => params[:year]), :name => name)
      end

    end
  end
