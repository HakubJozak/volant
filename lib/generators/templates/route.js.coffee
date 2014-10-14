<%= application_name.camelize %>.<%= class_name.camelize %>Route = Ember.Route.extend({
  model: ->
    @store.find('<%= class_name.downcase %>')
})
