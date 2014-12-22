Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user'
  apply_form: DS.belongsTo 'apply_form',async: true

  to: DS.attr 'string'
  cc: DS.attr 'string'
  bcc: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  html_body: DS.attr 'string'
  sent_at: DS.attr 'date'
  action: DS.attr 'string'

  # for the collision with {{action}} helper in Handlebars templates
  action_name: Ember.computed.alias('action')
  delivered: Ember.computed.alias('sent_at')
