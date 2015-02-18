Volant.ApplyFormsRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  newModelType: 'outgoing'
  
  queryParams:
    order: { refreshModel: true }
    sortAscending: { refreshModel: true }
    state: { refreshModel: true }

  setupController: (controller,model,queryParams) ->
    @_super(controller, model,queryParams)
    controller.set 'newModelType',@get('newModelType')
    @setupTagsController()

  model: (params) ->
    @store.find('apply_form', {
      p: params.page
      year: params.year
      q: params.query
      order: params.order
      state: params.state
      asc: params.sortAscending
      tag_ids: @controllerFor(@routeName).get('tags').mapBy('id')
    })

  title: -> "Applications"

  renderTemplate: ->
    @render('apply_forms')

  actions:
    pay: (form) ->
      @transitionTo('apply_form',form,{ queryParams: { anchor: 'payment-fields'}})

    search: ->
      @refresh()
      false

    yearChanged: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false
