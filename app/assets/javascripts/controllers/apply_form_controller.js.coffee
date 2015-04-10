Volant.ApplyFormController = Volant.ObjectController.extend

  needs: ['payment_means','starred_workcamps','workcamp_assignments','tagsSelect','countriesSelect','organizationsSelect']
  isDirty: Ember.computed.any('model.isDirty')

  means: [
    Ember.Object.create(label: "Cash", id: 'CASH'),
    Ember.Object.create(label: "Bank", id: 'BANK')
   ]

  starredWorkcamps: (->
    @store.find('workcamp',starred: true)
  ).property().volatile()

  workcampToAssign: (->
    @store.find('workcamp',@get('model.workcampToAssignId'))      
  ).property('model.workcampToAssignId')

  queryParams: ['anchor']
  anchor: null

  vefXmlUrl: (-> @attachmentUrl 'xml' ).property('model.id')
  vefHtmlUrl: (-> @attachmentUrl 'html' ).property('model.id')
  vefPdfUrl: (-> @attachmentUrl 'pdf' ).property('model.id')

  attachmentUrl: (sufix) ->
    if id = @get('model.id')
      "/apply_forms/#{id}/vef.#{sufix}"
