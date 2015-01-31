Volant.WorkcampAssignmentInsideWorkcampController = Ember.ObjectController.extend
  isCurrentWorkcamp: ( ->
    wc = @get('workcamp.id')
    current = @get('apply_form.current_workcamp.id')
    wc == current
  ).property('workcamp.id','apply_form.current_workcamp.id')  
  



