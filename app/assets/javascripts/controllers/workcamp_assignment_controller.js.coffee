Volant.WorkcampAssignmentController = Ember.ObjectController.extend({
  needs: 'apply_form'
  edited: false
  edited_or_new: Ember.computed.or('edited','isNew')

  actions:
    save: ->
      @get('model').save().then(
        (record) => @set('edited', false),
        (error)  -> console.error 'failed to save'
      )

    rollback: ->
      @get('model').rollback()
      @set('edited', false)

    edit: ->
      @set('edited',true)
      false

    remove: ->
      console.info 'removing'
      false

})
