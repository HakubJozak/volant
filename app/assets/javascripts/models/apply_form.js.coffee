Volant.ApplyForm = DS.Model.extend
  starred: DS.attr 'boolean'
  workcamp_assignments:  DS.hasMany 'workcamp_assignment'
  volunteer:  DS.belongsTo 'volunteer'
  confirmed: DS.attr 'isodate'
  created_at: DS.attr 'isodate'
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'
  state: DS.attr 'string'

  name: (->
    first = @get('volunteer.firstname')
    last = @get('volunteer.lastname')
    "#{last} #{first}"
    ).property('volunteer.firstname', 'volunteer.lastname')

  add_workcamp: (wc) ->
    console.info wc.id
