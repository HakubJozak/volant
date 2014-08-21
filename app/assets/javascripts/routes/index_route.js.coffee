Volant.IndexRoute = Ember.Route.extend({
  renderTemplate: ->
    @render('_menu',into: 'application', outlet: 'menu')
    @render('index')

})
