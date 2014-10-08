Volant.StarredWorkcampController = Volant.WorkcampController.extend({
  needs: ['apply_form']
  is_assigned: ( ->
    form = @get('controllers.apply_form.model')
    wc = @get('model')
    form.has_workcamp(wc)
   ).property('controllers.apply_form.workcamp_assignments.@each')
})
