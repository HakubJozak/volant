Volant.ApplicationRoute = Ember.Route.extend
  # setupController: (model,controller,queryParams) ->
  #   @controllerFor

  actions:
    yearChanged: ->
      false

    removeModal: ->
      @disconnectOutlet(outlet: 'modal',parent: 'application')
      false
