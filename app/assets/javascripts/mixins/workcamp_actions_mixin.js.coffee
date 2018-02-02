Volant.WorkcampActionsMixin = Ember.Mixin.create
  createApplyFormUrl: (->
    id = @get('id')
    type = @get('mode')
    "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
  ).property('id','mode')

  actions:
    createApplyForm: ->
      id = @get('id')
      type = @get('mode')
      window.location = "#/apply_forms/#{type}/new?fee=0&workcampToAssignId=#{id}"
      false

    cloneWorkcamp: ->
      id = @get('model.id')
      type = @get('model.type')
      window.location = "#/workcamps/#{type}/new?templateId=#{id}"
      false

    createBooking: ->
      @get('model').addBooking()
      @transitionTo 'workcamp', @get('model')
      false

    downloadParticipantsList: (exportType) ->
      window.location = "/workcamps/#{@get('id')}/participants.csv"
      false

    downloadPEF: (exportType) ->
      window.location = "/workcamps/#{@get('id')}/pef.xml"
      false
