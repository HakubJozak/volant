Volant.WorkcampController = Ember.ObjectController.extend Volant.FlashControllerMixin, {
  starred: false

  actions:
    toggle_starred: ->
      @toggleProperty('starred')

    save: ->
      SUCCESS = =>
        @show_flash('success','Saved.')

      ERROR = =>
        @show_flash('error','Failed.')

      @get('model').save().then(SUCCESS,ERROR)

    rollback: ->
      @get('model').rollback()

}
