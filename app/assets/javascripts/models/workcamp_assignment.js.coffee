Volant.WorkcampAssignment = DS.Model.extend
  state: DS.attr 'string'
  workcamp: DS.belongsTo('workcamp')
  apply_form: DS.belongsTo('apply_form')

  order: DS.attr 'number'
  accepted: DS.attr 'isodate'
  rejected: DS.attr 'isodate'
  asked: DS.attr 'isodate'
  infosheeted: DS.attr 'isodate'
