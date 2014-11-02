Volant.Workcamp = DS.Model.extend
  starred: DS.attr 'boolean'

  country: DS.belongsTo('country')
  organization: DS.belongsTo('organization')
  tags: DS.hasMany('tag')
  workcamp_intentions: DS.hasMany('workcamp_intention')
  workcamp_assignments: DS.hasMany('workcamp_assignment',async: true)

  name: DS.attr 'string'
  code: DS.attr 'string'
  state: DS.attr 'string'
  language: DS.attr 'string'
  begin: DS.attr 'isodate'
  end: DS.attr 'isodate'
  duration: DS.attr 'number'
  capacity: DS.attr 'number'
  minimal_age: DS.attr 'number'
  maximal_age: DS.attr 'number'
  area: DS.attr 'string'
  accomodation: DS.attr 'string'
  workdesc: DS.attr 'string'
  notes: DS.attr 'string'
  description: DS.attr 'string'
  extra_fee: DS.attr 'number'
  extra_fee_currency: DS.attr 'string'
  region: DS.attr 'string'
  capacity_natives: DS.attr 'number'
  capacity_teenagers: DS.attr 'number'
  capacity_males: DS.attr 'number'
  capacity_females: DS.attr 'number'
  airport: DS.attr 'string'
  train: DS.attr 'string'
  publish_mode: DS.attr 'string'
  tag_list: DS.attr 'string'

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

  requirements: DS.attr 'string'

  longitude: DS.attr 'number'
  latitude: DS.attr 'number'

  sci_id: DS.attr 'number'
  sci_code: DS.attr 'string'

  becameError: ->
   console.error 'there was an error saving a workcamp!'

  # becameInvalid: (errors) ->
  #  console.error 'workcamp became invalid'

  assignments_by_state: Ember.computed.sort 'workcamp_assignments', (wa,wb) ->
    priorities = [ 'infosheeted', 'accepted', 'asked','paid','not_paid', 'rejected', 'cancelled' ]

    a = priorities.indexOf wa.get('state')
    b = priorities.indexOf wb.get('state')

    if a > b
      1
    else if a < b
      -1
    else
       0

  for_email: ->
    hash = @_super()
    hash.begin_string = moment(@get('begin')).lang('cs').format('l')
    hash.end_string = moment(@get('end')).lang('cs').format('l')
    hash
