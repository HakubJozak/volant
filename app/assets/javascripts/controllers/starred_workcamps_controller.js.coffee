Volant.StarredWorkcampsController = Ember.ArrayController.extend({
  needs: [ 'apply_form' ]
  apply_form: Ember.computed.alias('controllers.apply_form.model')

  actions:
    add_wc_to_form: (wc) ->
      # TODO: add flash
      form = @get('apply_form')
      order = form.get('workcamp_assignments.lastObject.order') + 1 || 1
      wa = @store.createRecord('workcamp_assignment', workcamp: wc, apply_form: form, order: order)
      form.get('workcamp_assignments').pushObject(wa)
      wa.save()
      false
})
