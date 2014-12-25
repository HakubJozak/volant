Volant.EmailTemplateRoute = Volant.BaseRoute.extend
  after_save_route: 'email_templates'

  model: (params) ->
    @store.find 'email_template', params.email_template_id
