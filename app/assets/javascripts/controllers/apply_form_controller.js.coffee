Volant.ApplyFormController = Volant.ObjectController.extend({
  genders: [ { code: 'm', name: 'Male' }, { code: 'f', name: 'Female'}]
  isDirty: Ember.computed.any('model.isDirty','model.volunteer.isDirty')

  actions:
    toggle_starred: ->
      @toggleProperty('starred')
      @get('model').save()
      false

    save: ->
      SUCCESS = =>
        @show_flash('success','Saved.')

      ERROR = =>
        @show_flash('error','Failed.')

      store = (m) ->
        m.get('errors').clear();
        m.save().then(SUCCESS,ERROR)

      store(m) for m in @models()
      false

    rollback: ->
      reset = (m) ->
        m.get('errors').clear();
        m.rollback()

      reset(m) for m in @models()
      false

  models: -> [ @get('model'), @get('model.volunteer'), @get('model.payment') ]


})
