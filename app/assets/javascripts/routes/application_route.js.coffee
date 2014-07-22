Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
    @transitionTo('workcamps')
})
