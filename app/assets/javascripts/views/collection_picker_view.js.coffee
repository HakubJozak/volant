Volant.CollectionPickerView = Ember.Select.extend
  classNames: ['form-control']
  optionValuePath: "content.id"
  optionLabelPath: "content.name"
  onChange: null

  change: ->
    record = @get('selection')
    @get('target').pushObject(record)

    if action = @get('onChange')
      @send action, record         
