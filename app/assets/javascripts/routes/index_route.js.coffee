Volant.IndexRoute = Volant.BaseRoute.extend({
  model: ->
    Ember.RSVP.hash({
      starred_workcamps: @store.find('workcamp',starred: true)
      starred_apply_forms: @store.find('apply_form',starred: true)
    })

})
