Volant.ToggleView = Ember.View.extend
  property: null
  tagName: 'button'
  classNameBindings: [':btn',':btn-default','value:active']
  attributeBindings: ['type','value']
  type: 'button'

  click: ->
    @toggleProperty('value')
    true

