Volant.LittleWorkcampController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.Flash, Volant.ModeAwareMixin,
  needs: [ 'workcamps','application' ]
  workcamps: Ember.computed.alias('controllers.workcamps')
  isEditing: Ember.computed.alias('workcamps.isEditing')
  
  showActive: (-> @get('workcamps.showActive') ).property('workcamps.showActive')
  showIdle: (-> @get('workcamps.showIdle') ).property('workcamps.showIdle')
  showBookings: (-> @get('workcamps.showBookings') ).property('workcamps.showBookings')


  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')    
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('id')

  activeAssignments: (->
    @get('workcampAssignments').filterBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  # Applications that have this workcamp on the list later or further on
  idleAssignments: (->
    @get('workcampAssignments').rejectBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')  
  
  actions:
    save: ->
      @get('model').save().then (wc) =>
        @flash_info "'#{wc.get('name')}' saved."
      false  

    rollback: ->
      wc = @get('model')
      wc.rollback()
      @flash_info "'#{wc.get('name')}' reverted."        
      false  
