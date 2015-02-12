Volant.ApplyFormController = Volant.ObjectController.extend({
  needs: ['payment_means','starred_workcamps','workcamp_assignments','tags']
  isDirty: Ember.computed.any('model.isDirty','model.volunteer.isDirty')

  means: [
    Ember.Object.create(label: "Cash", id: 'CASH'),
    Ember.Object.create(label: "Bank", id: 'BANK')
   ]

  queryParams: ['anchor']
  anchor: null

  vefXmlUrl: (-> @attachmentUrl 'xml' ).property('model.id')
  vefHtmlUrl: (-> @attachmentUrl 'html' ).property('model.id')
  vefPdfUrl: (-> @attachmentUrl 'pdf' ).property('model.id')

  actions:
    rollback: ->
      for m in @models()
        m.get('errors').clear()
        m.rollback()      
      @transitionTo 'apply_forms'
      false

  models: -> [ @get('model'), @get('model.volunteer'), @get('model.payment') ]

  attachmentUrl: (sufix) ->
    if id = @get('model.id')
      "/apply_forms/#{id}/vef.#{sufix}"



})
