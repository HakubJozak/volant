Volant.ApplicationController = Ember.ObjectController.extend
  years: [ 'All','2016','2015','2014','2013','2012','2011','2010']
  year: moment().year().toString()

  modes: [ { name: 'Outgoing',id: 'outgoing' },
           { name: 'Incoming',id: 'incoming' },
           { name: 'LTV', id: 'ltv' } ]
  mode: 'outgoing'

  modeMenuTemplate: ( ->
    mode = @get('mode')
    "#{mode}/menu"
  ).property('mode')

  modeChange: ( ->
    url = switch (mode = @get('mode'))
            when 'incoming' then 'incoming_workcamps'
            when 'ltv' then 'ltv_workcamps'
            else 'index'
    $.cookie('volant-mode',mode)    
    @transitionToRoute(url)
  ).observes('mode')

  # outgoingMenu: Ember.computed.equal('mode','Outgoing')
  # incomingMenu: Ember.computed.equal('mode','Incoming')
  # ltvMenu: Ember.computed.equal('mode','LTV')

  flash: null
