Volant.BaseRoute = Ember.Route.extend Volant.AjaxToStoreMixin,
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
      console.log 'Saving',@currentModel
      @currentModel.get('errors').clear()
      @currentModel.save().then ( (wc) =>
        @go_to_plural_route(@currentModel)
        @flash_info 'Saved.'
       ), ( (e) =>
         if e.full_rails_message?
           @flash_error e.full_rails_message
         else
           @flash_error 'Save failed.'
       )
      false

    remove: ->
      if @currentModel.get('isNew')
        @currentModel.deleteRecord()
      else
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
    flash = Ember.Object.create(type: 'success', message: msg)
    @controllerFor('application').set('flash', flash)

  flash_error: (msg) ->
    flash = Ember.Object.create(type: 'error', message: msg)
    @controllerFor('application').set('flash',flash)

  prepareSelectControllers: ->
    @setupCountries()
    @controllerFor('workcamp_intentions').set('content', @store.filter('workcamp_intention',{},-> true))
    @controllerFor('organizations').set('content', @store.filter('organization',{},-> true))
    @controllerFor('tags').set('content', @store.filter('tag',{},-> true))

  setupCountries: () ->
    @controllerFor('countries').set('content', @store.filter('country',{},-> true))
