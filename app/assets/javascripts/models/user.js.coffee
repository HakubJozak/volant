Volant.User = DS.Model.extend
  email: DS.attr 'string'
  password: DS.attr 'string'
  first_name: DS.attr 'string'
  last_name: DS.attr 'string'

  firstname: Ember.computed.alias('first_name')
  lastname: Ember.computed.alias('last_name')

  name: (->
    "#{@get('first_name') || ''} #{@get('last_name') || ''}"
  ).property('first_name','last_name')

  for_email: ->
    @_super('name','firstname','lastname')
