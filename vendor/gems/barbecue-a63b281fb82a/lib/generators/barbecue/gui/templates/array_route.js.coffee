<%= application_name.camelize %>.<%= class_name.pluralize.camelize %>Route = <%= application_name.camelize %>.BaseRoute.extend({
  model: ->
    @store.find('<%= name %>')
})
