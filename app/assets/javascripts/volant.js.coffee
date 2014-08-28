#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require handlebars
#= require ember
#= require ember-data
#= require images


#= require moment
## require moment/czech.js
## require moment/english.js


#= require modernizr
#= jquery-ui/datepicker
#= date-polyfill.min

#= require_self
#= require ./store
#= require_tree ./mixins
#= require_tree ./models
#= require ./controllers/list_controller
#= require_tree ./controllers
#= require ./views/field_view
#= require_tree ./views
#= require_tree ./helpers
#= require_tree ./components
#= require_tree ./templates
#= require_tree ./routes
#= require ./router



# for more details see: http://emberjs.com/guides/application/
window.Volant = Ember.Application.create()
