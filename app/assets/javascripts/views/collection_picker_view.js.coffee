Volant.CollectionPickerView = Ember.Select.extend
  classNames: ['form-control']
  optionValuePath: "content.id"
  optionLabelPath: "content.name"
  onChange: null

  change: ->
    record = @get('selection')
    action = @get('onChange')
      
    if record
      @get('targetCollection').pushObject(record)

    if action?
      @get('controller').send(action,record)
