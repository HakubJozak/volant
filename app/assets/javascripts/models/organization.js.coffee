Volant.Organization = DS.Model.extend
  country: DS.belongsTo('country')
  email_contacts: DS.hasMany('email_contact',async: true)
  networks: DS.hasMany('network',async: true, embedded: 'always')

  name: DS.attr 'string'
  code: DS.attr 'string'
  address: DS.attr 'string'
  contact_person: DS.attr 'string'
  phone: DS.attr 'string'
  mobile: DS.attr 'string'
  fax: DS.attr 'string'
  website: DS.attr 'string'
  description: DS.attr 'string'  

  outgoing_email: DS.attr 'string'
  incoming_email: DS.attr 'string'
  ltv_email: DS.attr 'string'

  label: (->
    "#{@get('name')} (#{@get('country.name_en')})"
  ).property('name','country.id')
