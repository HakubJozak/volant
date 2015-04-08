Volant.ApplyFormWorkcampController = Ember.ObjectController.extend
  needs: ['apply_form']
  applyForm: Ember.computed.alias('controllers.apply_form.model')

  workcampAssignment: (->
    id = @get('applyForm.id')
    @get('model.workcampAssignments').findBy('applyForm.id', id)
  ).property('workcampAssignments.@each.id','applyForm.id')  
