Volant.ApplyFormController = Volant.ObjectController.extend({
  needs: ['payment_means','starred_workcamps','workcamp_assignments','tags']
  isDirty: Ember.computed.any('model.isDirty','model.volunteer.isDirty')

  means: [
    Ember.Object.create(label: "Cash", id: 'CASH'),
    Ember.Object.create(label: "Bank", id: 'BANK')
   ]

  queryParams: ['anchor']
  anchor: null

  vefXmlUrl: (->
    if id = @get('model.id')
      "/apply_forms/#{id}/vef.xml"
  ).property('model.id')

  vefHtmlUrl: (->
    if id = @get('model.id')
      "/apply_forms/#{id}/vef.html"
  ).property('model.id')

  vefPdfUrl: (->
    if id = @get('model.id')
      "/apply_forms/#{id}/vef.pdf"
  ).property('model.id')    

  actions:
    rollback: ->
      reset = (m) ->
        m.get('errors').clear();
        m.rollback()

      reset(m) for m in @models()
      false

  models: -> [ @get('model'), @get('model.volunteer'), @get('model.payment') ]


})
