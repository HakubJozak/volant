<%= application_name.camelize %>.<%= class_name.camelize %>Controller = Ember.ArrayController.extend({
  actions:
    add: ->
      <%= name %> = @store.createRecord('<%= name %>')
      @get('model').shiftObject(<%= name %>)

    remove: (<%= name %>) ->
      if <%= name %>.get('isNew')
        @get('model').removeObject(<%= name %>)
      else
        <%= name %>.destroyRecord()


})
