info = (msg) ->
  flash = Ember.Object.create(type: 'success', message: msg)
  @controllerFor('application').set('flash', flash)

error = (msg) ->
  flash = Ember.Object.create(type: 'error', message: msg)
  @controllerFor('application').set('flash',flash)

Volant.Flash = Ember.Mixin.create
  flashInfo: info
  flashError: error

  # legacy naming
  flash_info: info
  flash_error: error
