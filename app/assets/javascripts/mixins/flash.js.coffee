Volant.Flash = Ember.Mixin.create
  flash_info: (msg) ->
    flash = Ember.Object.create(type: 'success', message: msg)
    @controllerFor('application').set('flash', flash)

  flash_error: (msg) ->
    flash = Ember.Object.create(type: 'error', message: msg)
    @controllerFor('application').set('flash',flash)
