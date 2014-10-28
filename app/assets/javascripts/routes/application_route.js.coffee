Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  actions:
    removeModal: ->
#      $(".modal").modal("hide")
      @disconnectOutlet(outlet: 'modal',parent: 'application')
      false

  model: ->
   Ember.RSVP.hash({
   });
})
