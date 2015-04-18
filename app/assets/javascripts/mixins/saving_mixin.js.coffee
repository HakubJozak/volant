Volant.SavingMixin = Ember.Mixin.create
  actions:
    save: (redirect = true)->
      console.log 'Saving',@currentModel
      @currentModel.get('errors').clear()
      @currentModel.save().then ( (saved_record) =>
        @afterSave(saved_record, redirect: redirect)
       ), ( (e) =>
         if e.full_rails_message?
           @flash_error e.full_rails_message
         else
           @flash_error 'Save failed.'
       )
      false

    remove: (record) ->
      record ||= @currentModel
      return false unless confirm("Do you really want to delete '#{record.get('name')}'?")

      if record.get('isNew')
        record.deleteRecord()
        @afterRemove(record)
      else
        record.destroyRecord().then ( (record) =>
          @afterRemove(record)
          ), ( (e) =>
           console.error e
           @flash_error "Failed."
          )
      false


    rollback: ->
      @currentModel.get('errors').clear()
      @currentModel.rollback()
      @afterRollback(@currentModel)
      false

  # Override those
  afterRollback: (record) ->
    @go_to_plural_route(record)

  afterRemove: (record) ->
    @go_to_plural_route(record)
    @flash_info 'Deleted.'

  afterSave: (record) ->
    @go_to_plural_route(record)
    @flash_info('Saved.')

