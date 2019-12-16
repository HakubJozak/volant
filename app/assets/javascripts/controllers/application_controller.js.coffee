range = [ (moment().year() + 5)..2010 ]

Volant.ApplicationController = Ember.ObjectController.extend

  years: [ 'All' ].concat(range).map (a) -> a.toString()


          

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
