Volant.ApplyFormsRoute = Ember.Route.extend({
  model: (params) ->
    @store.find('apply_form', { page: 1 })

  renderTemplate: ->
    @render('_menu',into: 'application', outlet: 'menu')
    @render('apply_forms')

  actions:
    go_to_detail: (form) ->
      @transitionTo('apply_form',form)

})
