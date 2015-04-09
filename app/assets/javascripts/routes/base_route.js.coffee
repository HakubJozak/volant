Volant.BaseRoute = Ember.Route.extend Volant.AjaxToStoreMixin, Volant.Flash,
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
    closeModal: ->
      @disconnectOutlet 'modal'

    toggle_starred: (model) ->
      data = { star: { id: model.get('id'), model: model.constructor.typeKey.decamelize(), value: !model.get('starred') }}
      @ajax_to_store('/stars',data).then (payload) =>
        console.log 'Starred'

    createAssignment: (wc,form) ->
      order = form.get('workcamp_assignments.lastObject.order') + 1 || 1
      wa = @store.createRecord('workcamp_assignment', workcamp: wc, applyForm: form, order: order)
      wa.save().then =>
        code = wc.get('code')
        person = form.get('name')
        @flash_info "#{person} assigned to #{code}."
      false

    removeAssignment: (wa,warn) ->
      if warn
        who = wa.get('apply_form.name')
        wc = wa.get('workcamp.name')
        msg = "Do you really want to remove '#{wc}' from the application of #{who}?"
        return unless window.confirm(msg)

      if wa.get('isNew')
        @get('model').removeObject(wa)
      else
        wa.destroyRecord()
      @flash_info "Workcamp removed from the application."
      false

    userChangedMode: (mode) ->     
      route = switch (mode)
              when 'incoming' then 'incoming_workcamps'
              when 'ltv' then 'ltv_workcamps'
              else 'index'
      $.cookie('volant-mode',mode)
      console.info mode
      @transitionTo(route)
      false


    refresh: ->
      @refresh()
      false

    search: ->
      @refresh()
      false

    save: (redirect = true)->
      console.log 'Saving',@currentModel
      @currentModel.get('errors').clear()
      @currentModel.save().then ( (saved_record) =>
        @afterSave(saved_record, redirect: redirect)
       ), ( (e) =>
         if e.full_rails_message?
           @flash_error e.full_rails_message
         else
           @flash_error 'Save failed.'
       )
      false

    remove: (record) ->
      record ||= @currentModel
      if record.get('isNew')
        record.deleteRecord()
      else
        record.destroyRecord().then ( (record) =>
          @afterRemove(record)
          ), ( (e) =>
           console.error e
           @flash_error "Failed."
          )
      false

    confirmedRemove: (record) ->
      return unless confirm("Do you really want to delete '#{record.get('name')}'?")
      record.destroyRecord().then (=>
        @afterRemove(record)
        @flash_info 'Deleted.'
      ), ( (e) =>
        console.error e
        @flash_error "Failed."
      )
      false

    rollback: ->
      @currentModel.get('errors').clear()
      @currentModel.rollback()
      @afterRollback(@currentModel)
      false

  # Override those
  afterRollback: (record) ->
    @go_to_plural_route(record)

  afterRemove: (record) ->
    @go_to_plural_route()
    @flash_info 'Deleted.'

  afterSave: (record) ->
    @go_to_plural_route(record)
    @flash_info('Saved.')


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
    modelType = model.get('type') if model.get?
    if hash = @store.typeMapFor(modelType).metadata.pagination
      controller.set('controllers.pagination.model', Ember.Object.create(hash))
