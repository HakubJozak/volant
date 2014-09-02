Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  model: ->
   Ember.RSVP.hash({
       current_user:
         name: 'Jakub Hozak'
    });

})
