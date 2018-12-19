Barbecue.MenuDropdownComponent = Ember.Component.extend({
  layoutName: 'components/menu-dropdown'
  tagName: 'li'
  classNames: [ 'dropdown' ]
})

Ember.Handlebars.helper('menu-dropdown', Barbecue.MenuDropdownComponent)
