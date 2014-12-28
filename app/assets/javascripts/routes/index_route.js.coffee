Volant.IndexRoute = Volant.BaseRoute.extend({
  setupController: (controller,model,queryParams) ->
    @_super(controller,model,queryParams)

  model: ->
    Ember.RSVP.hash({
      starred_workcamps: @store.find('workcamp',starred: true)
      starred_apply_forms: @store.find('apply_form',starred: true)
      recentApplyFormsStats: @fetchJSON('/stats/recent_apply_forms')
    })

})
