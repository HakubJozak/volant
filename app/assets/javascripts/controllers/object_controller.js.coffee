Volant.ObjectController = Ember.ObjectController.extend(Volant.FlashControllerMixin, {
  starred: false

  actions:
    toggle_starred: ->
      @toggleProperty('starred')

    save: ->
      SUCCESS = =>
        @show_flash('success','Saved.')

      ERROR = =>
        if msg = @get('errors.firstObject')
          @show_flash('error',"#{msg.attribute} #{msg.message}")
        else
          'Failed.'

      model = @get('model')
      model.get('errors').clear();
      model.save().then(SUCCESS,ERROR)

    rollback: ->
      model = @get('model')
      model.get('errors').clear();
      model.rollback()

})
