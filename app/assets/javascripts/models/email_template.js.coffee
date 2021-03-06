Volant.EmailTemplate = DS.Model.extend
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

  eval_field: (field,context,error_hook) ->
    if source = @get(field)
      options = { helpers: Volant.EmailTemplate.helpers }
      try
        compiled = Handlebars.compile(source)
        compiled(context,options)
      catch e
        error_hook(e)
    else
      ''

Volant.EmailTemplate.helpers = {
  'long-date': (d) -> moment(d).format('LL')
  'short-date': (d) -> moment(d).format('L')
}
