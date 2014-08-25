Volant.WorkcampAssignment = DS.Model.extend
  state: DS.attr 'string'
  workcamp: DS.belongsTo('workcamp')
  apply_form: DS.belongsTo('apply_form')

  order: DS.attr 'number'
  accepted: DS.attr 'date'
  rejected: DS.attr 'date'
  asked: DS.attr 'date'
  infosheeted: DS.attr 'date'
