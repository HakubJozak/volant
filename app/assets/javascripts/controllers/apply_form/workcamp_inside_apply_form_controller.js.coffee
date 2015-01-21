Volant.WorkcampInsideApplyFormController = Volant.WorkcampController.extend
  needs: ['apply_form']
  
  isAssigned: ( ->
    form = @get('apply_form.model')
    wc = @get('model')
    form.has_workcamp(wc)
   ).property('apply_form.workcamp_assignments.@each')

