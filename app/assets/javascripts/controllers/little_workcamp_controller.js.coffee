Volant.LittleWorkcampController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.ModeAwareMixin,
  needs: [ 'workcamps','application' ]
  editing_visible: Ember.computed.alias('controllers.workcamps.editing_visible')

  showIdleAssignments: false

  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')    
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('id')
  

  activeAssignments: (->
    @get('workcampAssignments').filterBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  # Applications that have this workcamp on the list later of further on
  idleAssignments: (->
    @get('workcampAssignments').rejectBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')  
  
