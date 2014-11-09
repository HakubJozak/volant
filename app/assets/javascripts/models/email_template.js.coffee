Volant.EmailTemplate = DS.Model.extend({
  action: DS.attr 'string'
  title: DS.attr 'string'
  to: DS.attr 'string'
  from: DS.attr 'string'
  cc: DS.attr 'string'
  bcc: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'

  # for the collision with {{action}} helper in Handlebars templates
  action_name: Ember.computed.alias('action')

  eval_subject: (context) ->
    Handlebars.compile(@get('subject'))(context)

  eval_body: (context) ->
    Handlebars.compile(@get('body'))(context)
})
