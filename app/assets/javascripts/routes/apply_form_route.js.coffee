Volant.ApplyFormRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  toolbar: 'apply_form/toolbar'

  model: (params) ->
    @store.find('apply_form', params.apply_form_id)

  afterSave: (record,options = {}) ->
    @flash_info('Saved.')
    @send 'goToApplyForms' if options.redirect

  afterRemove: (record) ->
    @flash_info('Deleted.')
    @send 'goToApplyForms'

  afterRollback: (record) ->
    @send 'goToApplyForms'

  title: (model) -> "#{model.get('name')}"

  setupController: (controller,model,queryParams) ->
    @controllerFor('workcamp_assignments').set('model',model.get('workcamp_assignments'))
    @_super(controller,model,queryParams)
    @controllerFor('payment').set('model',model.get('payment'))

  actions:
    addWorkcamp: (wc) ->
      @send('createAssignment',wc,@currentModel)
      false

    rollback: ->
      for m in [ @currentModel, @currentModel.get('payment') ]
        continue unless m
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
