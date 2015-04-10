Volant.LittleWorkcampController = Ember.ObjectController.extend
  needs: [ 'workcamps','application' ]
  mode: Ember.computed.alias('controllers.application.mode')
  incomingMode: Ember.computed.alias('controllers.application.incomingMode')
  editing_visible: Ember.computed.alias('controllers.workcamps.editing_visible')

  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')    
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('id')
  

  activeAssignments: (->
    @get('workcampAssignments').filterBy('workcamp.id',@get('id'))
  ).property('workcampAssignments.@each.workcamp.id','id')
