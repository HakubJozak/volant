Volant.Router.map () ->
#  @resource 'year', path '/:year'
  @resource 'apply_forms'
  @resource 'apply_form', path: '/apply_forms/:apply_form_id', ->
    @resource 'workcamp_assignments'

  @resource 'workcamps'
  @resource('workcamp', path: '/workcamps/:workcamp_id')
  @resource 'organizations'
  @resource('organization', path: '/organizations/:organization_id')


# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
