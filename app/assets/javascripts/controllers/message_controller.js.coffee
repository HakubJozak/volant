Volant.MessageController = Volant.ObjectController.extend({
  actions:
    send: ->
      @set('model.deliver_on_save',true)
      @get('model').save (-> @send('removeModal')), (->)

    close_and_save: ->
      @set('model.deliver_on_save',false)
      @get('model').save (-> @send('removeModal')), (->)
})
