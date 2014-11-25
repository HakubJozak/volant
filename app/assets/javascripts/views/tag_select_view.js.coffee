Volant.TagSelectView = Ember.Select.extend({
  optionValuePath: "content.id"
  optionLabelPath: "content.name"

  watch: (->
    tag = @get('selection')
    @get('target').pushObject(tag)
  ).observes('selection')
})
