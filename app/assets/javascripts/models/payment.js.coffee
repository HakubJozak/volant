Volant.Payment = DS.Model.extend
  apply_form: DS.belongsTo('apply_form')
  amount: DS.attr 'number'
  received: DS.attr 'isodate'
  description: DS.attr 'string'
  account: DS.attr 'string'
  mean: DS.attr 'string'
  returned_date: DS.attr 'isodate'
  returned_amount: DS.attr 'number'
  return_reason: DS.attr 'string'
  bank_code: DS.attr 'string'
  spec_symbol: DS.attr 'string'
  var_symbol: DS.attr 'string'
  const_symbol: DS.attr 'string'
