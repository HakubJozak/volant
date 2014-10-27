Volant.Organization = DS.Model.extend
  country: DS.belongsTo('country')
  email_contacts: DS.hasMany('email_contact')
  name: DS.attr 'string'
  code: DS.attr 'string'
  address: DS.attr 'string'
  contact_person: DS.attr 'string'
  phone: DS.attr 'string'
  mobile: DS.attr 'string'
  fax: DS.attr 'string'
  website: DS.attr 'string'

  outgoing_email: (->
    'change-me@google.com'
  ).property('email_contacts.@each')
