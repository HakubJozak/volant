Volant.Message = DS.Model.extend
  user: DS.belongsTo 'user'
  applyForm: DS.belongsTo 'apply_form',async: true
  workcamp: DS.belongsTo 'workcamp'
  attachments: DS.hasMany 'attachment'
  to: DS.attr 'string'
  cc: DS.attr 'string'
  bcc: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  html_body: DS.attr 'string'
  action: DS.attr 'string'
  sentAt: DS.attr 'isodate'
  createdAt: DS.attr 'isodate'

  # for the collision with {{action}} helper in Handlebars templates
  action_name: Ember.computed.alias('action')
  delivered: Ember.computed.alias('sentAt')
  name: Ember.computed.alias('subject')

  # legacy naming fallback
  apply_form: Ember.computed.alias('applyForm')
