Volant.ApplyFormsRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  toolbar: 'apply_forms/toolbar'
  default_filter: -> { type: 'outgoing' }
  newModelType: 'outgoing'

  queryParams:
    order: { refreshModel: true }
    sortAscending: { refreshModel: true }
    state: { refreshModel: true }

  setupController: (controller,model,transition) ->
    @_super(controller, model,transition)
    controller.set 'newModelType',@get('newModelType')

  afterRemove: (wc) ->
    @send 'goToApplyForms'

  model: (params) ->
    filter = @default_filter()
    filter.p = params.page
    filter.per_page = @controllerFor('pagination').get('perPage')
    filter.year = params.year
    filter.q = params.query
    filter.order = params.order
    filter.state = params.state
    filter.asc = params.sortAscending
    filter.tag_ids = @controllerFor(@routeName).get('tags').mapBy('id')
    @store.find('apply_form', filter)

  title: -> "Applications"

  actions:
    pay: (form) ->
      @transitionTo('apply_form',form,{ queryParams: { anchor: 'payment-fields'}})

    emailSelected: (form) ->    
      @console.info @model.map  
      @render 'apply_form/action_picker',outlet: 'modal', controller: 'apply_form_action_picker'
      
    search: ->
      @refresh()
      false

    yearChanged: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false
