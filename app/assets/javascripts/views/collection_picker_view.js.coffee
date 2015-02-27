Volant.CollectionPickerView = Ember.Select.extend
  classNames: ['form-control']
  optionValuePath: "content.id"
  optionLabelPath: "content.name"
  onChange: null

  change: ->
    record = @get('selection')
    @get('targetCollection').pushObject(record)
    action = @get('onChange')

    if action?
      @get('controller').send(action,record)
  
