Volant.ToggleMixin = Ember.Mixin.create
  actions:
    toggle: (property) ->
      @toggleProperty(property)
      false

