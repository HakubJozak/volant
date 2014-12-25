Volant.WorkcampAssignmentController = Ember.ObjectController.extend({
  needs: 'apply_form'
  edited: false
  edited_or_new: Ember.computed.or('edited','isNew')

  status: (->
    if @get('isCurrentWorkcamp')
      'active'
    else if @get('order') < @get('apply_form.current_assignment.order')
      'text-muted'

    # if @get('apply_form.cancelled')
    #   return 'text-danger'

    # if @get('isCurrentWorkcamp')
    #   if @get('accepted')
    #     'text-success'
    #   else if @get('rejected')
    #     'text-danger'
    #   else if @get('asked')
    #     'text-warning'
    #   else
    #     'text-active'
  ).property('isCurrentWorkcamp','order','apply_form.current_assignment.order')

  isCurrentWorkcamp: (->
    @get('workcamp.id') == @get('apply_form.current_workcamp.id')
  ).property('model')

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
      @get('model').destroyRecord()
      false

})
