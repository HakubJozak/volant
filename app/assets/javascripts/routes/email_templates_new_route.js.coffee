Volant.EmailTemplatesNewRoute = Volant.EmailTemplateRoute.extend
  model: ->
    @store.createRecord('email_template')
