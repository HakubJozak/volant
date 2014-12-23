Volant.BaseRoute = Ember.Route.extend
  afterModel: (model,transition) ->
    if title = @get('title')
      $(document).attr('title', "#{title.call(this,model)} - Volant")
    else
      'Volant'

  setupController: (controller,model) ->
    @setupPagination(controller,model)
    @_super(controller,model)

  actions:
    toggle_starred: (model) ->
      data = { star: { id: model.get('id'), model: model.constructor.typeKey.decamelize(), value: !model.get('starred') }}
      @ajax_to_store('/stars',data).then (payload) =>
        console.log 'Starred'

    createAssignment: (wc,form) ->
      order = form.get('workcamp_assignments.lastObject.order') + 1 || 1
      wa = @store.createRecord('workcamp_assignment', workcamp: wc, apply_form: form, order: order)
      form.get('workcamp_assignments').pushObject(wa)
      wc.get('workcamp_assignments').pushObject(wa)
      wa.save().then =>
        code = wc.get('code')
        person = form.get('name')
        @flash_info "#{person} assigned to #{code}."
      false

    removeAssignment: (wa) ->
      if wa.get('isNew')
        @get('model').removeObject(wa)
      else
        wa.destroyRecord()
      @flash_info "Workcamp removed from the application."
      false

    save: ->
      @currentModel.get('errors').clear()
      @currentModel.save().then ( (wc) =>
        @go_to_plural_route(@currentModel)
        @flash_info 'Saved.'
       ), ( (e) =>
         console.warn e
         @flash_error 'Failed.'
       )
      false

    remove: ->
      @currentModel.destroyRecord().then (=>
        @flash_info 'Deleted.'
        @go_to_plural_route()
        ), ( (e) =>
         console.error e
         @flash_error "Failed."
        )
      false


    rollback: ->
      @currentModel.get('errors').clear()
      @currentModel.rollback()
      @go_to_plural_route()
      false

  # ----- Normal Methods ------

  go_to_plural_route: ->
    next_route = @currentModel.constructor.typeKey.decamelize().pluralize()
    @transitionTo next_route if @routeName != next_route

  setupPagination: (controller,model) ->
    modelType = model.get('type') if model.get?
    if hash = @store.typeMapFor(modelType).metadata.pagination
      controller.set('controllers.pagination.model', Ember.Object.create(hash))

  flash_info: (msg) ->
    @controllerFor('application').set('flash', {type: 'success', message: msg })

  flash_error: (msg) ->
    @controllerFor('application').set('flash', {type: 'error', message: msg })

  ajax_to_store: (url,data = {}) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')
      data.authenticity_token = csrf_token

      try
        $.post url, data, (response) =>
          console.info 'Payload', response
          @store.pushPayload(response)
          resolve(response)
      catch e
        reject(e)
