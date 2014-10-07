Volant.WorkcampAssignmentsController = Ember.ArrayController.extend({
  needs: 'apply_form'
  actions:
    # add: ->
    #   form = @get('controllers.apply_form.model')
    #   wa = @store.createRecord('workcamp_assignment', { apply_form: form } )
    #   @get('model').shiftObject(wa)

    remove: (wa) ->
      if wa.get('isNew')
        @get('model').removeObject(wa)
      else
        wa.destroyRecord()

})
