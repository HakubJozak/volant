Volant.IndexRoute = Volant.BaseRoute.extend
  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)

  model: (params) ->
    Ember.RSVP.hash({
      starred_workcamps: @store.find('workcamp',starred: true)
      starred_apply_forms: @store.find('apply_form',starred: true)
      outgoingStats:  @fetchJSON("/stats/outgoing?year=#{params.year}")
    })

  actions:
    yearChanged: ->
      @refresh()
