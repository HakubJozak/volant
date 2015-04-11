Volant.GenderSelectView = Ember.Select.extend
  content: [ { code: 'm', name: 'Male' }, { code: 'f', name: 'Female'}]
  optionLabelPath: 'content.name'
  optionValuePath: 'content.code'

