Volant.ApplyFormIndexRoute = Volant.BaseRoute.extend
  redirect: (model) ->
    @transitionTo('workcamp_assignments',model)
