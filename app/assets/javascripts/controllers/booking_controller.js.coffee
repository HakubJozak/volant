Volant.BookingController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.Flash,
  needs: ['countriesSelect','organizationsSelect','application']
  isEditing: (-> @get('isNew')).property('isNew')

  actions:
    save: ->
      @get('model').save().then ( (booking) =>
         @set 'isEditing',false
         booking.get('workcamp').reload()
         @flashInfo 'Saved'
       ), ( (e) =>
         @flashError 'Save failed.'
       )
      false

    remove: ->
      return unless confirm('Do you really want to delete the booking?')
      booking = @get('model')
      wc = booking.get('workcamp')
      if booking.get('isNew')  
        booking.deleteRecord()
      else
        booking.destroyRecord().then ->
          wc.reload()
      false

    rollback: ->
      @set 'isEditing',false
      booking = @get('model')

      if booking.get('isNew')
        booking.deleteRecord()
      else
        booking.get('errors').clear()
        booking.rollback()
      false
