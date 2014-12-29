Volant.LittleWorkcampController = Ember.ObjectController.extend
  needs: [ 'workcamps' ]
  editing_visible: Ember.computed.alias('controllers.workcamps.editing_visible')
