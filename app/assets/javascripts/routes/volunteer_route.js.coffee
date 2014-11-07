Volant.VolunteerRoute = Volant.BaseRoute.extend({
  model: (params) ->
    @store.find 'volunteer', params.volunteer_id
})
