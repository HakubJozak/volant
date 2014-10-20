Volant.ApplicationRoute = Ember.Route.extend({
  beforeModel: ->
#    @transitionTo('workcamps')

  actions:
    showModal: ->
      @controllerFor('message').set('model', Ember.Object.create(body: 'sdfdsf'))
      @render 'message', into: 'application',outlet: 'modal'
      false

    removeModal: ->
      @disconnectOutlet(outlet: 'modal',parentView: 'application')
      false

  model: ->
   Ember.RSVP.hash({
   });
})
