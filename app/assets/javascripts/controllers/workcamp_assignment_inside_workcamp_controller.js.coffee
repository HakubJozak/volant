Volant.WorkcampAssignmentInsideWorkcampController = Ember.ObjectController.extend
  isRelevant: Ember.computed.or('isAcceptedByAny','isCurrentWorkcamp')

  isCurrentWorkcamp: ( ->
    wc = @get('workcamp.id')
    current = @get('apply_form.current_workcamp.id')
    wc == current
  ).property('workcamp.id','apply_form.current_workcamp.id')

  isAcceptedByAny: (->
    !@get('apply_form.current_assignment.accepted')?
  ).property('apply_form.current_assignment.accepted')
