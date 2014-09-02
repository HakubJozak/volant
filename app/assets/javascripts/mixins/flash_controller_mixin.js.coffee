# TODO: there must be a better way to implement this
Volant.FlashControllerMixin = Ember.Mixin.create({
  flash: null
  needs: [ 'application' ]

  show_flash: (type,message) ->
    @set('controllers.application.flash', { type: type, message: message })
    @hide_flash_later() unless type == 'error'

  hide_flash_later: ->
    app_controller =
    Ember.run.later((=>
      @set('controllers.application.flash',null)
     ),3000)

})
