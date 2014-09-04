Volant.WorkcampsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    filter = { q: params.query, p: params.page }
    filter.year = params.year unless params.year == 'All'

    attrs = [ 'from','to','min_duration','max_duration', 'min_age','max_age',
              'free', 'free_males', 'free_females' ]

    for attr in attrs
      if params[attr]
        filter[attr] = params[attr]

    @store.filter 'workcamp', filter, (wc) ->
      true

  title: -> "Workcamps"

  renderTemplate: ->
  #   @render('workcamps/filter',into: 'application', outlet: 'filter')
  #   @render('workcamps')
    @render('year_select',into: 'application', outlet: 'item_controls')
    @render('workcamps')

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
