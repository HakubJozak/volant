Volant.WorkcampApplyFormController = Ember.ObjectController.extend
  needs: ['workcamp']
  workcamp: Ember.computed.alias('controllers.workcamp.model')

  workcampAssignment: (->
    id = @get('workcamp.id')
    @get('model.workcampAssignments').findBy('workcamp.id', id)
  ).property('workcampAssignments.@each.id','workcamp.id')

  # deprecated - use `workcampAssignment`
  isAssigned: ( ->
    wc = @get('controllers.workcamp.model')
    form = @get('model')
    form.has_workcamp(wc)
   ).property('controllers.workcamp.workcampAssignments.@each')
