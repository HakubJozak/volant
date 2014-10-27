Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user'
  email_template: DS.belongsTo 'email_template',async: false
  workcamp_assignment: DS.belongsTo 'workcamp_assignment',async: true
  apply_form: DS.belongsTo 'apply_form',async: false

  to: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'
  sent_at: DS.attr 'date'
  action: DS.attr 'string'

  # transient flag
  deliver_on_save: DS.attr 'boolean', defaultValue: false

  template_changed: (->
    context = {
     user: if @get('user')? then @get('user').for_email() else null
     volunteer: @get('apply_form.volunteer').for_email()
     wc: @get('apply_form.current_workcamp').for_email()
    }

    tmpl = @get('email_template')
    @set 'subject',tmpl.eval_subject(context)
    @set 'body',tmpl.eval_body(context)
  ).observes('email_template')
