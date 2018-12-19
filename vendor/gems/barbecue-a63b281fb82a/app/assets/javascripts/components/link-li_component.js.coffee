Barbecue.LinkLiComponent = Ember.Component.extend({
  tagName: 'li',
  classNameBindings: ['active'],
  active: (->
    @get('childViews').anyBy('active')
  ).property('childViews.@each.active')
})

Ember.Handlebars.helper('link-li', Barbecue.LinkLiComponent)
