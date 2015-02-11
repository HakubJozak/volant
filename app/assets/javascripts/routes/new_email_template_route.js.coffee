Volant.NewEmailTemplateRoute = Volant.EmailTemplateRoute.extend
  templateName: 'email_template'
  controllerName: 'email_template'  
  model: ->
    @store.createRecord('email_template')
