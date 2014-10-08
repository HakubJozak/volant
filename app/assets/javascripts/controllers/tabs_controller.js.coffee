Volant.TabsController = Ember.ArrayController.extend({
  actions:
    activate_tab: (current) ->
      t.set('active',false) for t in @get('model')
      current.set('active',true)
      false
})
