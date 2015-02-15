Volant.Account = DS.Model.extend
  organization: DS.belongsTo('organization')
  seasonStart: DS.attr 'isodate'
  organizationResponseLimit: DS.attr 'number'
  infosheetWaitingLimit: DS.attr 'number'
