Volant.LittleWorkcampController = Ember.ObjectController.extend
  needs: [ 'workcamps' ]
  editing_visible: Ember.computed.alias('controllers.workcamps.editing_visible')

  activeAssignments: (->
    @get('workcampAssignments').filterBy('workcamp.id',@get('id'))
  ).property('workcampAssignments.@each.workcamp.id','id')
