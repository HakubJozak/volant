Volant.LittleWorkcampController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.Flash, Volant.ModeAwareMixin,
  needs: [ 'workcamps','application' ]
  workcamps: Ember.computed.alias('controllers.workcamps')
  isEditing: Ember.computed.alias('workcamps.isEditing')

  isActiveVisible: null

  showActive: ( (property,value) ->
    if value?
      console.log 'setting',value
      val = if value == true  then true else null
      @set 'isActiveVisible', val
      val  
    else
      @get('isActiveVisible') || @get('workcamps.showActive')
  ).property('isActiveVisible','workcamps.showActive')
  
  showIdle: (-> @get('workcamps.showIdle') ).property('workcamps.showIdle')
  showBookings: (-> @get('workcamps.showBookings') ).property('workcamps.showBookings')

  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('model.id','mode')

  activeAssignments: (->
    @get('workcampAssignments').filterBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  # Applications that have this workcamp on the list later or further on
  idleAssignments: (->
    @get('workcampAssignments').rejectBy('applyForm.currentWorkcamp.id',@get('id'))
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  actions:
    createBooking: ->
      @get('model').addBooking()
      @transitionTo 'workcamp', @get('model')
      false

    save: ->
      @get('model').save().then (wc) =>
        @flash_info "'#{wc.get('name')}' saved."
      false

    rollback: ->
      wc = @get('model')
      wc.rollback()
      @flash_info "'#{wc.get('name')}' reverted."
      false
