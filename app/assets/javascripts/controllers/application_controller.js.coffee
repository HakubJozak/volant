Volant.ApplicationController = Ember.ObjectController.extend
  years: [ 'All','2016','2015','2014','2013','2012','2011','2010']
  year: moment().year().toString()

  modes: [ 'Outgoing','Incoming','LTV']
  mode: 'Outgoing'

  modeMenuTemplate: ( ->
    mode = @get('mode').toLocaleLowerCase()
    "#{mode}/menu"
  ).property('mode')

  modeName: (->
    @get('mode').toLocaleLowerCase()
  ).property('mode')

  modeChange: ( ->
    url = switch @get('mode').toLocaleLowerCase()
            when 'incoming' then '/'
            when 'outgoing' then '/'
            when 'ltv' then '/'
    @transitionToRoute('index')
  ).observes('mode')

  # outgoingMenu: Ember.computed.equal('mode','Outgoing')
  # incomingMenu: Ember.computed.equal('mode','Incoming')
  # ltvMenu: Ember.computed.equal('mode','LTV')

  flash: null
