Volant.SavingMixin = Ember.Mixin.create
  actions:
    saveOnly: (record) ->
      @_saveRecord(record,false)
  
    save: (record)->
      @_saveRecord(record,true)
      false

    remove: (record,redirect = true) ->
      record ||= @currentModel
      return false unless confirm("Do you really want to delete '#{record.get('name')}'?")

      if record.get('isNew')
        record.deleteRecord()
        @afterRemove(record,redirect)
      else
        record.destroyRecord().then ( (record) =>
          @afterRemove(record,redirect)
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

  _saveRecord: (record,redirect) ->
    record ||= @currentModel
    console.log 'Saving',record
    record.get('errors').clear()
    record.save().then ( (saved_record) =>
      @afterSave(saved_record, redirect: redirect)
     ), ( (e) =>
       if e.full_rails_message?
         @flash_error e.full_rails_message
       else
         @flash_error 'Save failed.'
     )
  

  # Override those
  afterRollback: (record) ->
    @go_to_plural_route(record)

  afterRemove: (record,redirect) ->
    @flash_info 'Deleted.'    
    @go_to_plural_route(record) if redirect    

  afterSave: (record) ->
    @go_to_plural_route(record)
    @flash_info('Saved.')
