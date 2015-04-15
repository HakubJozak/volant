Volant.Booking = DS.Model.extend
  gender: DS.attr 'string'
  expiresAt: DS.attr 'isodate'
  country: DS.belongsTo 'country'
  organization: DS.belongsTo 'organization'
  workcamp: DS.belongsTo 'workcamp'

