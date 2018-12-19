Barbecue.RemoveButtonComponent = Ember.Component.extend({
  layoutName: 'components/barbecue/remove-button'
  icon: 'times'
  click: ->
    @sendAction('remove',@get('param'))
    false
})

Ember.Handlebars.helper('remove-button', Barbecue.RemoveButtonComponent)
