Volant.StarredWorkcampsRoute = Ember.Route.extend({
  model: ->
    @store.filter 'workcamp',{ starred: true }, (wc) ->
      wc.get('starred')

  actions:
    add_wc_to_form: (wc) ->
      # -----  MOVE TO CONTROLLER AND ADD FLASH
      form = @modelFor('apply_form')
      order = form.get('workcamp_assignments.lastObject.order') + 1
      wa = @store.createRecord('workcamp_assignment', workcamp: wc, apply_form: form, order: order)
      form.get('workcamp_assignments').pushObject(wa)
      wa.save()
      # -----
      false
})
