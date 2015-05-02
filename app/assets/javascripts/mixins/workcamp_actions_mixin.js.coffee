Volant.WorkcampActionsMixin = Ember.Mixin.create
  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('model.id','mode')

  actions: 
    createBooking: ->
      @get('model').addBooking()
      @transitionTo 'workcamp', @get('model')
      false

    downloadParticipantsList: (exportType) ->
      window.location = "/workcamps/#{@get('id')}/participants.csv"
      false
