Volant.Router.map () ->
  @resource 'workcamps', ->
    @resource('workcamp', path: '/workcamps/:workcamp_id')
  @resource('forms')



# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
