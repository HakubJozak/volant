Volant.ToggleView = Ember.View.extend
  property: null
  tagName: 'button'
  classNameBindings: [':btn',':btn-default']
  attributeBindings: ['type']
  type: 'button'

  click: ->
    name = @get('property')
    @get('controller').toggleProperty(name)
    true

  didInsertElement: ->  
    throw "Missing property to toggle" unless @get('property')
