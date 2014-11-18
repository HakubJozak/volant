<%= application_name.camelize %>.<%= class_name.camelize %>Route = <%= application_name.camelize %>.BaseRoute.extend({
  model: (params) ->
    @store.find('<%= name %>',params.<%= name %>_id)
})
