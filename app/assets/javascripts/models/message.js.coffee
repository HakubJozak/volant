Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user'
  email_template: DS.belongsTo 'email_template',async: false
  apply_form: DS.belongsTo 'apply_form',async: true

  to: DS.attr 'string'
  cc: DS.attr 'string'
  bcc: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'
  html_body: DS.attr 'string'
  sent_at: DS.attr 'date'
  action: DS.attr 'string'

  # for the collision with {{action}} helper in Handlebars templates
  action_name: Ember.computed.alias('action')
  delivered: Ember.computed.alias('sent_at')

  template_changed: (->
    @get('email_template').then (tmpl) =>
      if tmpl
        context = @message_context()
        @set 'subject',tmpl.eval_subject(context)
        @set 'body',tmpl.eval_body(context)
  ) # .observes('email_template')


  message_context: () ->
    context = {}

    if user = @get('user')
      context.user = @get('user').for_email()

    if apply_form = @get('apply_form')
      context.apply_form = apply_form.for_email()

    if volunteer = @get('apply_form.volunteer')
      context.volunteer = volunteer.for_email()

    if workcamp = @get('apply_form.workcamp')
      context.workcamp = workcamp.for_email()
      # legacy alias
      context.wc = context.workcamp

    if org = workcamp.get('organization')
      context.organization = org.for_email()
