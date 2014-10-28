Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  actions:
    removeModal: ->
      $(".modal").modal("hide")
      false

  model: ->
   Ember.RSVP.hash({
   });
})
