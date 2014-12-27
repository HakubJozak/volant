Volant.Router.map ->

  @route 'payments'
  @resource 'volunteers'
  @resource 'volunteer', path: '/volunteers/:volunteer_id'

  @resource 'apply_forms'
  @route 'apply_form', path: '/apply_forms/:apply_form_id'
  @route 'new_apply_form', path: '/apply_forms/new'

  @resource 'workcamps'
  @resource 'workcamp', path: '/workcamps/:workcamp_id'
  @route 'new_workcamp', path: '/workcamps/:type/new'




  @resource 'imported_workcamps'

  @resource 'incoming_workcamps', path: '/incoming/workcamps'
  @resource 'ltv_workcamps', path: '/ltv/workcamps'

  @resource 'organizations'
  @resource 'organization', path: '/organizations/:organization_id'

  @resource 'message', {path: '/messages/:message_id'}
  @resource 'messages'

  @resource 'users', ->
    @route 'new'
    @resource 'user', {path: ':user_id'}

  @resource 'countries', ->
    @route 'new'
    @resource 'country', {path: ':country_id'}

  @resource 'tags', ->
    @route 'new'
    @resource 'tag', {path: ':tag_id'}

  @resource 'workcamp_intentions', ->
    @route 'new'
    @resource 'workcamp_intention', {path: ':workcamp_intention_id'}

  @resource 'email_templates', ->
    @route 'new'
    @resource 'email_template', {path: ':email_template_id'}
