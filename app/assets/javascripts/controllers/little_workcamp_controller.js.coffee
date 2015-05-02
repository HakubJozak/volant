Volant.LittleWorkcampController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.Flash, Volant.ModeAwareMixin, Volant.WorkcampActionsMixin,
  needs: [ 'workcamps','application' ]
  workcamps: Ember.computed.alias('controllers.workcamps')
  isEditing: Ember.computed.alias('workcamps.isEditing')

  isActiveVisible: null
  isBookingVisible: null
  isIdleVisible: null

  showActive: Volant.toggleWithFallback('isActiveVisible','workcamps.showActive')
  showIdle: Volant.toggleWithFallback('isIdleVisible','workcamps.showIdle')
  showBookings: Volant.toggleWithFallback('isBookingsVisible','workcamps.showBookings')

  activeAssignments: (->
    @get('workcampAssignments').filterBy('applyForm.currentWorkcamp.id',@get('id')).sortBy('applyForm.state.priority')
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  # Applications that have this workcamp on the list later or further on
  idleAssignments: (->
    @get('workcampAssignments').rejectBy('applyForm.currentWorkcamp.id',@get('id')).sortBy('applyForm.gender')
  ).property('workcampAssignments.@each.applyForm.currentWorkcamp.id','id')

  bookings: (->
    @get('model.bookings').sortBy('gender')
  ).property('model.bookings.@each.gender')

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
