Volant.WorkcampsRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find('workcamp', { q: params.query, p: params.page, year: params.year })

  title: -> "Workcamps"

  renderTemplate: ->
  #   @render('workcamps/filter',into: 'application', outlet: 'filter')
  #   @render('workcamps')
    @render('year_select',into: 'application', outlet: 'item_controls')
    @render('workcamps')

  actions:
    refresh: ->
      @refresh()

    go_to_detail: (wc) ->
      @transitionTo('workcamp',wc)

})
