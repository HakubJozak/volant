Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user',async: true
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
     user: @get('user').for_email()
     volunteer: @get('apply_form.volunteer').for_email()
     wc: @get('apply_form.current_workcamp').for_email()
    }

    tmpl = @get('email_template.subject_template')
    @set 'subject',tmpl(context)
  ).observes('email_template') #.on('init')
