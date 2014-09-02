Volant.WorkcampsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    filter = { q: params.query, p: params.page }
    filter.year = params.query unless params.year == 'All'
    filter.from = params.from if params.from
    filter.to = params.to if params.to
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
