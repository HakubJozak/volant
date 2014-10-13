Volant.Router.map () ->
#  @resource 'year', path '/:year'
  @resource 'users', ->
    @resource 'user', {path: ':user_id'}
  @resource 'apply_forms'
  @route 'payments'
  @route 'apply_form', path: '/apply_forms/:apply_form_id', ->
    @resource 'workcamp_assignments'
    @resource 'starred_workcamps'
  @resource 'workcamps'
  @resource('workcamp', path: '/workcamps/:workcamp_id')
  @resource 'organizations'
  @resource('organization', path: '/organizations/:organization_id')


# Volant.WorkcampsPagesRoute = Ember.Route.extend({
#   model: (params) ->
#     Ember.Object.create id: params.page_id
# })
