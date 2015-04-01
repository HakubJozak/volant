Volant.Volunteer = DS.Model.extend Volant.PersonalAttributesMixin,
  applyForms: DS.hasMany 'apply_form', async: true
