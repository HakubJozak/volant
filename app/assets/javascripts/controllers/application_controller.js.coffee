Volant.ApplicationController = Ember.ObjectController.extend({
  years: [ 'All','2015','2014','2013','2012','2011','2010']
  year: '2014'

  modes: [ 'Outgoing','Incoming','Long Term']
  mode: 'Outgoing'

  flash: null

  show_flash: ((type,message) ->
    if @get('flash')
      Ember.run.later((=> @set('flash',null)),5000)
  ).observes('flash')

})
