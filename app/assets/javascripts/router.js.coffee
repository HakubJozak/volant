Volant.Router.map () ->
  @resource 'apply_forms', ->
    @resource('apply_form', path: '/:apply_form_id')
  @resource 'workcamps', ->
    @resource('workcamp', path: '/:workcamp_id')



# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
