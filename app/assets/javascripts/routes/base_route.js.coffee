Volant.BaseRoute = Ember.Route.extend Volant.AjaxToStoreMixin, Volant.Flash, Volant.SavingMixin,

  renderTemplate: ->
    @_super()

    if tmpl = @get('toolbar')
      @render(tmpl,outlet: 'footer',into: 'application')
    else if @_paginationData()
      @render('pagination',outlet: 'footer',into: 'application',controller: 'pagination')
    else if @currentModel.save? and @currentModel.constructor != DS.RecordArray
      @render('toolbars/record_actions',outlet: 'footer',into: 'application')
    else
      @disconnectOutlet('footer',parentView: 'application')

  afterModel: (model,transition) ->
    if title = @get('title')
      $(document).attr('title', "#{title.call(this,model)} - Volant")
    else
      'Volant'

  setupController: (controller,model) ->
    @setupPagination(controller,model)
    @_super(controller,model)

  activate: ->
    @_super()
    window.scrollTo(0,0)

  actions:
    set_page: (p) ->
      @controllerFor(@routeName).set('page',p)
      @refresh()
      false

    closeModal: ->
      @disconnectOutlet 'modal'
      false

    toggle_starred: (model) ->
      data = { star: { id: model.get('id'), model: model.constructor.typeKey.decamelize(), value: !model.get('starred') }}
      @ajax_to_store('/stars',data).then (payload) =>
        console.log 'Starred'
      false

    createAssignment: (wc,form) ->
      order = form.get('workcamp_assignments.lastObject.order') + 1 || 1
      # wa = @store.createRecord('workcamp_assignment',)
      data = { workcamp_assignment: { workcamp_id: wc.get('id'), apply_form_id: form.get('id')}}

      @ajax_to_store('/workcamp_assignments',data).then =>
        code = wc.get('code')
        person = form.get('name')
        @flash_info "#{person} assigned to #{code}."
      false

    removeAssignment: (wa) ->
      who = wa.get('apply_form')
      wc = wa.get('workcamp')
      msg = "Do you really want to remove '#{wc.get('name')}' from the application of #{who.get('name')}?"
      return unless window.confirm(msg)

      if wa.get('isNew')
        @get('model').removeObject(wa)
      else
        wa.destroyRecord().then =>
          @flash_info "Workcamp removed from the application."
          wc.then (w) -> w.reload() 
      false

    userChangedMode: (mode) ->
      route = switch (mode)
              when 'incoming' then 'incoming_workcamps'
              when 'ltv' then 'ltv_workcamps'
              else 'index'
      Volant.saveSettings('mode',mode)
      @transitionTo(route)
      false


    refresh: ->
      @refresh()
      false

    search: ->
      @refresh()
      false


  # ----- Normal Methods ------

  go_to_plural_route: (record = @currentModel) ->
    next_route = record.constructor.typeKey.decamelize().pluralize()

    if @routeName != next_route
      console.log "Transiting to #{@routeName}"
      @transitionTo next_route

  # goToSingularRoute: (record) ->
  #   next_route = record.constructor.typeKey.decamelize()
  #   @transitionTo(next_route,record) if @routeName != next_route

  setupPagination: (controller,model) ->
    if data = @_paginationData()
      controller.set('controllers.pagination.model', data)

  currentAccount: ->
    id = $('meta[name="current-account-id"]').attr('content')
    @store.find('account',id)

  _paginationData: (model = @currentModel) ->
    modelType = model.get? && model.get('type')
    if hash = @store.typeMapFor(modelType).metadata.pagination
      Ember.Object.create(hash)
