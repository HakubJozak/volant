Volant.ModeAwareMixin = Ember.Mixin.create
  needs: ['application']
  mode: Ember.computed.alias('controllers.application.mode')
  incomingMode: Ember.computed.alias('controllers.application.incomingMode')
