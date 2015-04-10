Volant.ApplicationController = Ember.ObjectController.extend
  years: [ 'All','2016','2015','2014','2013','2012','2011','2010']
  year: moment().year().toString()

  mode: 'outgoing'
  incomingMode: Ember.computed.equal('mode','incoming')

  modeMenuTemplate: ( ->
    mode = @get('mode')
    "#{mode}/menu"
  ).property('mode')

  # outgoingMenu: Ember.computed.equal('mode','Outgoing')
  # incomingMenu: Ember.computed.equal('mode','Incoming')
  # ltvMenu: Ember.computed.equal('mode','LTV')

  flash: null
