Volant.ApplyFormIndexRoute = Volant.BaseRoute.extend
  redirect: (model,transition) ->
    params = transition.queryParams
    @transitionTo('workcamp_assignments',model,{queryParams: params})
