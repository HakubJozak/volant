Volant.CollectionPickerView = Ember.Select.extend({
  classNames: ['form-control']
  optionValuePath: "content.id"
  optionLabelPath: "content.name"

  watch: (->
    tag = @get('selection')
    @get('target').pushObject(tag)
  ).observes('selection')
})
