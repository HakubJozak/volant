Volant.Organization = DS.Model.extend
  country: DS.belongsTo('country')

  name: DS.attr 'string'
  code: DS.attr 'string'
  triple_code: DS.attr 'string'
  address: DS.attr 'string'
  contact_person: DS.attr 'string'
  phone: DS.attr 'string'
  mobile: DS.attr 'string'
  fax: DS.attr 'string'
  website: DS.attr 'string'
