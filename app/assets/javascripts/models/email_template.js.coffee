Volant.EmailTemplate = DS.Model.extend({
  action: DS.attr 'string'
  description: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'
  wrap_into_template: DS.attr 'string'

  # for the collision with {{action}} helper in Handlebars templates
  action_name: Ember.computed.alias('action')
})
