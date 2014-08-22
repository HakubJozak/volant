# for more details see: http://emberjs.com/guides/models/defining-models/

Volant.WorkcampAssignment = DS.Model.extend
  order: DS.attr 'number'
  accepted: DS.attr 'date'
  rejected: DS.attr 'date'
  asked: DS.attr 'date'
  infosheeted: DS.attr 'date'
