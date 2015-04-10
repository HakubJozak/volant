Volant.Router.map ->

  @route 'payments'
  @resource 'volunteers'
  @resource 'volunteer', path: '/volunteers/:volunteer_id'

  @resource 'apply_forms'
  @resource 'ltv_apply_forms', path: '/ltv/apply_forms'
  @resource 'incoming_apply_forms', path: '/incoming/apply_forms'
  @route 'new_apply_form', path: '/apply_forms/:type/new'
  @route 'apply_form', path: '/apply_forms/:apply_form_id'

  @route 'new_workcamp', path: '/workcamps/:type/new'
  @resource 'workcamp', path: '/workcamps/:workcamp_id'
  @resource 'workcamps'

  @resource 'imported_workcamps'


  @resource 'incoming_workcamps', path: '/incoming/workcamps'
  @resource 'ltv_workcamps', path: '/ltv/workcamps'

  @resource 'organizations'
  @resource 'new_organization', path: '/organizations/new'
  @resource 'organization', path: '/organizations/:organization_id'


  @resource 'message', {path: '/messages/:message_id'}
  @resource 'new_message', {path: '/apply_forms/:apply_form_id/messages/new/:action_name'}
  @resource 'messages'

  @resource 'users', ->
    @route 'new'
    @resource 'user', {path: ':user_id'}

  @resource 'countries', ->
    @route 'new'
    @resource 'country', {path: ':country_id'}

  @resource 'networks', ->
    @route 'new'
    @resource 'network', {path: ':network_id'}

  @resource 'tags', ->
    @route 'new'
    @resource 'tag', {path: ':tag_id'}

  @resource 'workcamp_intentions', ->
    @route 'new'
    @resource 'workcamp_intention', {path: ':workcamp_intention_id'}

  @resource 'email_templates', ->
  @route 'new_email_template', {path: '/email_templates/new'}
  @resource 'email_template', {path: '/email_templates/:email_template_id'}

  @route 'account'
