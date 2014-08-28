# TODO: there must be a better way to implement this
Volant.FlashControllerMixin = Ember.Mixin.create({
  flash: null
  needs: [ 'application' ]

  show_flash: (type,message) ->
    console.info message
    @set('controllers.application.flash', { type: type, message: message })
    @hide_flash_later()

  hide_flash_later: ->
    Ember.run.later((=>
      console.debug 'flash hided'
      @set('controllers.application.flash',null)
     ),3000)

})
