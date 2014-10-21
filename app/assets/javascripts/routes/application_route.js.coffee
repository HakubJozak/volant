Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  actions:
    removeModal: ->
      @disconnectOutlet(outlet: 'modal',parentView: 'application')
      false

  model: ->
   Ember.RSVP.hash({
   });
})
