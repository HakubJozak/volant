Volant.ApplicationRoute = Ember.Route.extend
  actions:
    yearChanged: ->
      false

    removeModal: ->
      @disconnectOutlet(outlet: 'modal',parent: 'application')
      false
