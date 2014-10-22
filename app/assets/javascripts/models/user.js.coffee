Volant.User = DS.Model.extend
  email: DS.attr 'string'
  password: DS.attr 'string'
  first_name: DS.attr 'string'
  last_name: DS.attr 'string'

  name: (-> "#{@get('first_name') || ''} #{@get('last_name') || ''}" ).property('first_name','last_name')
