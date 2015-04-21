Volant.WorkcampAssignment = DS.Model.extend
  state: DS.attr 'string'
  workcamp: DS.belongsTo('workcamp', inverse: 'workcampAssignments', async: true)
  applyForm: DS.belongsTo('apply_form', inverse: 'workcampAssignments',async: true)

  position: DS.attr 'number'
  accepted: DS.attr 'isodate'
  rejected: DS.attr 'isodate'
  asked: DS.attr 'isodate'
  infosheeted: DS.attr 'isodate'

  isActive: (->
    @get('id') == @get('applyForm.currentAssignment.id')
  ).property('id','applyForm.currentAssignment.id')

  # legacy naming fallback
  order: Ember.computed.alias('position')
  apply_form: Ember.computed.alias('applyForm')
