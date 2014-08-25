Volant.ApplyForm = DS.Model.extend
  workcamp_assignments:  DS.hasMany 'workcamp_assignment'
  volunteer:  DS.belongsTo 'volunteer'

  confirmed: DS.attr 'date'
  created_at: DS.attr 'date'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'
