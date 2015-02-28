Volant.Account = DS.Model.extend
  organization: DS.belongsTo('organization')
  seasonEnd: DS.attr 'isodate'
  organizationResponseLimit: DS.attr 'number'
  infosheetWaitingLimit: DS.attr 'number'
