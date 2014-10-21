Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user',async: true
  email_template: DS.belongsTo 'email_template',async: true
  workcamp_assignment: DS.belongsTo 'email_template',async: true

  to: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'
  sent_at: DS.attr 'date'
  action: DS.attr 'string'

  # transient flag
  deliver_on_save: DS.attr 'boolean', defaultValue: false
