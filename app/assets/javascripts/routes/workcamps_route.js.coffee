Volant.WorkcampsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    filter = { q: params.query, p: params.page }
    filter.year = params.year unless params.year == 'All'

    attrs = [ 'from','to','min_duration','max_duration', 'min_age','max_age',
              'free', 'free_males', 'free_females' ]

    for attr in attrs
      if params[attr]
        filter[attr] = params[attr]

    @store.find 'workcamp', filter #, (wc) ->
      # debugger
      # (!params.year? or wc.year == params.year) and
      # (!params.from? or wc.from >= params.from) and
      # (!params.to? or wc.to <= params.to)

  title: -> "Workcamps"

  setupController: (controller,model) ->
    @_super(controller, model);
    @setupPagination(controller,model)
    @controllerFor('countries').set('content', @store.find('country'));
    @controllerFor('workcamp_intentions').set('content', @store.find('workcamp_intention'));
    @controllerFor('organizations').set('content', @store.find('organization'));
    @controllerFor('tags').set('content', @store.find('tag'));

  actions:
    refresh: ->
      @refresh()
      false

    search: ->
      @refresh()
      false

    go_to_detail: (wc) ->
      @transitionTo('workcamp',wc)

})
