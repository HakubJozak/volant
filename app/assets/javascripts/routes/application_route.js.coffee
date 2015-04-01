Volant.ApplicationRoute = Ember.Route.extend
  mode: Ember.computed.alias('controller.mode')

  setupController: (controller) ->
    @_super.call(arguments)    
    if m = $.cookie('volant-mode')
      controller.set('mode',m)

  actions:
    goToWorkcamps: ->
      route = switch @get('mode')
                when 'incoming' then 'incoming_workcamps'
                when 'ltv' then 'ltv_workcamps'
                else  'workcamps'
      @transitionTo(route)
      false

    goToApplyForms: ->
      route = switch @get('mode')
                when 'incoming' then 'incoming_apply_forms'
                when 'ltv' then 'ltv_apply_forms'
                else  'apply_forms'
      @transitionTo(route)
      false
    yearChanged: ->
      false

    removeModal: ->
      @disconnectOutlet(outlet: 'modal',parent: 'application')
      false
