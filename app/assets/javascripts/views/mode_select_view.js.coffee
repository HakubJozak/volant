Volant.ModeSelectView = Ember.Select.extend
  content: [ { name: 'Outgoing',id: 'outgoing' },
           { name: 'Incoming',id: 'incoming' },
           { name: 'LTV', id: 'ltv' } ]

  classNames: ["form-control"]
  optionLabelPath: 'content.name'
  optionValuePath: 'content.id'               

  change: ->
    @get('controller').send('userChangedMode',@get('value'))


