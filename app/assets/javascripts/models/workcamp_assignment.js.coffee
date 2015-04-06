Volant.WorkcampAssignment = DS.Model.extend
  state: DS.attr 'string'
  workcamp: DS.belongsTo('workcamp', inverse: 'workcampAssignments', async: true)
  applyForm: DS.belongsTo('apply_form', inverse: 'workcampAssignments')

  order: DS.attr 'number'
  accepted: DS.attr 'isodate'
  rejected: DS.attr 'isodate'
  asked: DS.attr 'isodate'
  infosheeted: DS.attr 'isodate'

  # legacy fallback      
  apply_form: Ember.computed.alias('applyForm')
