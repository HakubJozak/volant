Volant.WorkcampInsideApplyFormController = Volant.WorkcampController.extend
  needs: ['apply_form']
  apply_form: Ember.computed.alias 'controllers.apply_form'
  
  isAssigned: ( ->
    form = @get('apply_form.model')
    wc = @get('model')
    form.has_workcamp(wc)
   ).property('apply_form.workcamp_assignments.@each')

  relevantFreePlaces: (->
  ).property('apply_form.gender','model.free_places','model.free_places_for_females','model.free_places_for_males')
