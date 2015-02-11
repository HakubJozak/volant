Volant.EmailTemplateController = Volant.ObjectController.extend
  after_save_route: 'email_templates'



  workcampAttributes: (-> @_attributes(Volant.Workcamp) ).property()
  applicationAttributes: (-> @_attributes(Volant.ApplyForm) ).property()
  volunteerAttributes: (-> @_attributes(Volant.Volunteer) ).property()
  userAttributes: (-> @_attributes(Volant.User) ).property()      


  _attributes: (model) ->
    Ember.get(model,'attributes').keys.toArray()
