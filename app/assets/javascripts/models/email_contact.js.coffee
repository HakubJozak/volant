Volant.EmailContact = DS.Model.extend
  organization: DS.belongsTo('organization')
  active: DS.attr 'boolean'
  address: DS.attr 'string'
  name: DS.attr 'string'
  notes: DS.attr 'string'
  kind: DS.attr 'string'
