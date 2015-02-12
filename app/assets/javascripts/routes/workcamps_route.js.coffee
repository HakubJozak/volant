Volant.WorkcampsRoute = Volant.BaseRoute.extend
  default_filter: -> {}
  newWorkcampType: 'outgoing'
  
  queryParams:
    order: { refreshModel: true }
    sortAscending: { refreshModel: true }

  model: (params) ->
    filter = @default_filter()
    filter.q = params.query
    filter.p = params.page
    filter.order = params.order
    filter.asc = params.sortAscending    
    filter.year = params.year unless params.year == 'All'

    attrs = [ 'from','to','min_duration','max_duration', 'min_age','max_age',
              'free', 'free_males', 'free_females' ]

    for attr in attrs
      if params[attr]
        filter[attr] = params[attr]

    controller = @controllerFor(@routeName)
    filter['tag_ids'] = controller.get('tags').mapBy('id')
    filter['workcamp_intention_ids'] =controller.get('workcamp_intentions').mapBy('id')
    filter['country_ids'] = controller.get('countries').mapBy('id')
    filter['organization_ids'] = controller.get('organizations').mapBy('id')

    @store.find 'workcamp', filter #, (wc) ->
      # debugger
      # (!params.year? or wc.year == params.year) and
      # (!params.from? or wc.from >= params.from) and
      # (!params.to? or wc.to <= params.to)

  title: -> "Workcamps"

  setupController: (controller,model,queryParams) ->
    @_super(controller, model,queryParams)
    controller.set 'newWorkcampType',@get('newWorkcampType')
    @prepareSelectControllers()

  actions:
    new: (type) ->
      @transitionTo 'workcamps.new',type

    save: ->
      @flash_info('Saving...')
      for wc in @modelFor('workcamps').filterBy('isDirty',true)
        wc.save().then (=>
          @flash_info("Saved #{wc.get('code')}.")), =>
          @flash_error('Failed.')
      false

    yearChanged: ->
      @refresh()
      false
