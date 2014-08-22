# for more details see: http://emberjs.com/guides/models/defining-models/

Volant.ApplyForm = DS.Model.extend
  fee: DS.attr 'number'
  generalRemarks: DS.attr 'string'
  motivation: DS.attr 'string'
  confirmed: DS.attr 'date'
