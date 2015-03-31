Volant.ApplyFormRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  afterSave: (record) ->
    @flash_info('Saved.')
    @send 'goToApplyForms'

  afterRemove: (record) ->
    @flash_info('Deleted.')
    @send 'goToApplyForms'

  afterRollback: (record) ->
    @send 'goToApplyForms'

  title: (model) -> "#{model.get('name')}"

  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)

    starred = @store.filter 'workcamp',{ starred: true }, (wc) ->
      wc.get('starred')

    @setupTagsController()
    @controllerFor('starred_workcamps').set('model',starred)
    @controllerFor('workcamp_assignments').set('model',model.get('workcamp_assignments'))
    @controllerFor('payment').set('model',model.get('payment'))

  actions:
    addWorkcamp: (wc) ->
      @send('createAssignment',wc,@currentModel)
      false

    rollback: ->
      models = [ @currentModel, @currentModel.get('payment') ]
      for m in models
        m.get('errors').clear()
        m.rollback()
      @send 'goToApplyForms'
      false

    reactivate: ->
      @currentModel.set 'cancelled',null
      @currentModel.save()

    create_payment: ->
      form = @modelFor('apply_form')
      payment = @store.createRecord('payment',apply_form: form,amount: form.get('fee'),mean: 'BANK', received: new Date())
      @controllerFor('payment').set('content',payment)
      false
