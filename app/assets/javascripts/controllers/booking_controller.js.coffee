Volant.BookingController = Ember.ObjectController.extend Volant.ToggleMixin, Volant.Flash,
  needs: ['countriesSelect','organizationsSelect','application']
  isEditing: (-> @get('isNew')).property('isNew')

  actions:
    save: ->
      @get('model').save().then ( (saved_booking) =>
         @set 'isEditing',false
         @flashInfo 'Saved'
       ), ( (e) =>
         @flashError 'Save failed.'
       )
      false

    remove: ->
      return unless confirm('Do you really want to delete the booking?')
      booking = @get('model')
      booking.deleteRecord()
      booking.save()
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
