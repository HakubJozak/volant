Volant.EmailTemplateRoute = Ember.Route.extend({
  after_save_route: 'email_templates'

  model: (params) ->
    @store.find 'email_template', params.email_template_id

  actions:
    save: ->
      SUCCESS = =>
        @show_flash('success','Saved.')
        if route = @get('after_save_route')
          @transitionToRoute(route)

      ERROR = =>
        if msg = @get('errors.firstObject')
          @show_flash('error',"#{msg.attribute} #{msg.message}")
        else
          'Failed.'

      model = @get('model')
      model.get('errors').clear();
      model.save().then(SUCCESS,ERROR)
      false


})
