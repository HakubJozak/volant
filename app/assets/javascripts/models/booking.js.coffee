Volant.Booking = DS.Model.extend
  gender: DS.attr 'string'
  country: DS.belongsTo 'country'
  organization: DS.belongsTo 'organization'
  workcamp: DS.belongsTo 'workcamp', inverse: 'bookings'
  expiresAt: DS.attr 'isodate'
  isExpired: DS.attr 'boolean'
