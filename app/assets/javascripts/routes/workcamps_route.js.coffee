Volant.WorkcampsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('workcamp', { page: 1 })

  renderTemplate: ->
#    @render('workcamps/filter',into: 'application', outlet: 'filter')
    @render('workcamps')


  # renderTemplate: ->
  #   @render('_menu',into: 'application', outlet: 'menu')
  #   @render('workcamps')

  actions:
    go_to_detail: (wc) ->
      @transitionTo('workcamp',wc)

})
