Volant.WorkcampsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    filter = { q: params.query, p: params.page }
    filter.year = params.year unless params.year == 'All'
    filter.from = params.from if params.from
    filter.to = params.to if params.to
    filter.min_duration = params.min_duration if params.min_duration
    filter.max_duration = params.max_duration if params.max_duration
    filter.min_age = params.min_age if params.min_age
    filter.max_age = params.max_age if params.max_age
    @store.find('workcamp', filter)

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
