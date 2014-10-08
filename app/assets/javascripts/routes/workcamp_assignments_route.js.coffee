Volant.WorkcampAssignmentsRoute = Ember.Route.extend({
  model: (params) ->
    @modelFor('apply_form').get('workcamp_assignments')
})
