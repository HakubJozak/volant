Volant.ApplyFormController = Volant.ObjectController.extend({
  needs: ['payment_means','starred_workcamps','workcamp_assignments']
  isDirty: Ember.computed.any('model.isDirty','model.volunteer.isDirty')

  means: [
    Ember.Object.create(label: "Cash", id: 'CASH'),
    Ember.Object.create(label: "Bank", id: 'BANK')
   ]


  queryParams: ['anchor']
  anchor: null

  actions:
    toggle_starred: ->
      @toggleProperty('starred')
      @get('model').save()
      false

    rollback: ->
      reset = (m) ->
        m.get('errors').clear();
        m.rollback()

      reset(m) for m in @models()
      false

  models: -> [ @get('model'), @get('model.volunteer'), @get('model.payment') ]


})
