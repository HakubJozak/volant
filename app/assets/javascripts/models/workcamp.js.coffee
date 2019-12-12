Volant.Workcamp = DS.Model.extend Ember.Copyable,
  starred: DS.attr 'boolean'
  type: DS.attr 'string'

  country: DS.belongsTo('country')
  organization: DS.belongsTo('organization')
  tags: DS.hasMany('tag',embedded: 'always')
  workcampIntentions: DS.hasMany('workcamp_intention',embedded: 'always')
  workcampAssignments: DS.hasMany('workcamp_assignment',async: true)
  import_changes: DS.hasMany('import_change')
  applyForms: DS.hasMany('apply_form',async: true,inverse: 'workcamps')
  bookings: DS.hasMany('booking')

  allOrganizationsEmails: DS.attr 'string'
  allApplicationsEmails: DS.attr 'string'

  name: DS.attr 'string'
  code: DS.attr 'string'
  state: DS.attr 'string'
  language: DS.attr 'string'
  begin: DS.attr 'isodate'
  end: DS.attr 'isodate'
  variableDates: DS.attr 'boolean'
  duration: DS.attr 'number'
  minimal_age: DS.attr 'number'
  maximal_age: DS.attr 'number'
  area: DS.attr 'string'
  accommodation: DS.attr 'string'
  workdesc: DS.attr 'string'
  notes: DS.attr 'string'
  description: DS.attr 'string'
  price: DS.attr 'number'
  defaultPrice: DS.attr 'number'  
  extraFee: DS.attr 'number'
  extraFeeCurrency: DS.attr 'string'
  region: DS.attr 'string'
  airport: DS.attr 'string'
  train: DS.attr 'string'
  publish_mode: DS.attr 'string'
  requirements: DS.attr 'string'
  projectSummary: DS.attr 'string'
  partnerOrganization: DS.attr 'string'
  longitude: DS.attr 'number'
  latitude: DS.attr 'number'

  createdAt: DS.attr 'isodate'
  updatedAt: DS.attr 'isodate'

  # TODO: extract Placement data type
  places: DS.attr 'number'
  places_for_males: DS.attr 'number'
  places_for_females: DS.attr 'number'

  accepted_places: DS.attr 'number'
  accepted_places_males: DS.attr 'number'
  accepted_places_females: DS.attr 'number'

  asked_for_places: DS.attr 'number'
  asked_for_places_males: DS.attr 'number'
  asked_for_places_females: DS.attr 'number'

  free_places: DS.attr 'number'
  free_places_for_males: DS.attr 'number'
  free_places_for_females: DS.attr 'number'

  capacity: DS.attr 'number'
  capacity_males: DS.attr 'number'
  capacity_females: DS.attr 'number'
  capacity_natives: DS.attr 'number'
  capacity_teenagers: DS.attr 'number'
  free_capacity: DS.attr 'number'
  free_capacity_males: DS.attr 'number'
  free_capacity_females: DS.attr 'number'

  # legacy fallbacks
  workcamp_assignments: Ember.computed.alias('workcampAssignments')
  workcamp_intentions:  Ember.computed.alias('workcampIntentions')

  becameError: ->
   console.error 'there was an error saving a workcamp!'

  from: Ember.computed.alias('begin')
  to: Ember.computed.alias('end')

  computedOrSetDuration: (->
    @get('duration') || @get('computedDuration')
  ).property('duration','computedDuration')

  computedDuration: (->
    from = @get('from')
    to = @get('to')

    if from? and to?
      moment(to).diff(from,'days') + 1
    else
      null
  ).property('from','to')

  addBooking: ->
    bookings = @get('bookings')
    year = moment().year()
    # expires at 1st of May by default
    expires = moment(new Date(year,5,1))
    bookings.createRecord(expiresAt: expires)

  clone: ->
    copy = @get('store').createRecord('workcamp')
    setter = (attr) =>
      copy.set(attr, @get(attr))

    hasManySetter = (attr) =>
      @get(attr).forEach (record) ->
        copy.get(attr).pushObject(record)

    @eachAttribute(setter)
    setter('country')
    setter('organization')
    hasManySetter('workcampIntentions')
    hasManySetter('tags')
    copy

  for_email: ->
    hash = @_super('allOrganizationsEmails','allApplicationsEmails')
    hash.begin_string = moment(@get('begin')).format('D.M.YYYY')
    hash.end_string = moment(@get('end')).format('D.M.YYYY')
    hash
