Volant.ToggleMixin = Ember.Mixin.create
  actions:
    toggle: (property) ->
      console.log property
      @toggleProperty(property)
      false
