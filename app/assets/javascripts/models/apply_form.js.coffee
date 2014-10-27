Volant.ApplyForm = DS.Model.extend
  current_workcamp:  DS.belongsTo 'workcamp'
  current_assignment:  DS.belongsTo 'workcamp_assignment'
  message: DS.belongsTo 'message',async: true
  state: DS.attr 'state'

  workcamp_assignments:  DS.hasMany 'workcamp_assignment', async: true, inverse: 'apply_form'
  volunteer:  DS.belongsTo 'volunteer'
  payment:  DS.belongsTo 'payment'

  starred: DS.attr 'boolean'
  confirmed: DS.attr 'isodate'
  created_at: DS.attr 'isodate'
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'

  name: Ember.computed.alias('volunteer.name')
  email: Ember.computed.alias('volunteer.email')

  has_workcamp: (wc) ->
    @get('workcamp_assignments').any (wa) ->
      wa.get('workcamp.id') == wc.get('id')

  add_workcamp: (wc) ->
    console.info wc.id
