<%= application_name.camelize %>.<%= class_name.pluralize.camelize %>NewRoute = <%= application_name.camelize %>.BaseRoute.extend({
  renderTemplate: ->
    @render('<%= name %>')

  model: ->
    @store.createRecord('<%= name %>')
})
