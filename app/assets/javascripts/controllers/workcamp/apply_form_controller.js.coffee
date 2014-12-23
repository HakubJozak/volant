Volant.ApplyFormInsideWorkcampController = Volant.ApplyFormController.extend
  needs: ['workcamp']
  isAssigned: ( ->
    wc = @get('controllers.workcamp.model')
    form = @get('model')
    form.has_workcamp(wc)
   ).property('controllers.workcamp.workcamp_assignments.@each')
