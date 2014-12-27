Volant.SmallFlashView = Ember.View.extend
  elementName: 'p'
  classNameBindings: [ ':flash','type' ]
  templateName: 'small_flash'

  type: Ember.computed.alias('flash.type')
  message: Ember.computed.alias('flash.message')

  actions:
    close: ->
      @$().hide()

  showFlash: ( ->
    if msg = @get('message')
      console.log 'Showing flash:',msg
      @$().fadeIn()
      Ember.run.later((=> @$().fadeOut() ),5000)
    else
      console.log 'No flash to show.'
  ).observes('flash').on('init')
