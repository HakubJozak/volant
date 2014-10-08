Volant.LinkLiComponent = Em.Component.extend({
  tagName: 'li',
  classNameBindings: ['active'],
  active: (->
    @get('childViews').anyBy('active')
  ).property('childViews.@each.active')
})

Em.Handlebars.helper('link-li', Volant.LinkLiComponent)
