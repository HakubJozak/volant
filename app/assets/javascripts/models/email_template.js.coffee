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

  eval_field: (field,context) ->
    if source = @get(field)
      f =  Handlebars.compile(source)(context)
      console.info field,f
      f
    else
      ''
})
