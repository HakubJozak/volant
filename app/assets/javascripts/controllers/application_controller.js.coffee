Volant.ApplicationController = Ember.ObjectController.extend(Volant.FlashControllerMixin, {
  years: [ 'All','2015','2014','2013','2012','2011','2010']
  year: '2014'
  flash: null

  show_flash: ((type,message) ->
    if @get('flash')
      @hide_flash_later()
  ).observes('flash')

  hide_flash_later: ->
    Ember.run.later((=>
      @set('flash',null)
     ),5000)

})
