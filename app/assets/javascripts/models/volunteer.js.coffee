Volant.Volunteer = DS.Model.extend({
  apply_forms: DS.hasMany 'apply_form'
  age: DS.attr 'number'
  firstname: DS.attr 'string'
  lastname: DS.attr 'string'
  gender: DS.attr 'string'
  email: DS.attr 'string'
  phone: DS.attr 'string'
  speak_well: DS.attr 'string'
  speak_some: DS.attr 'string'
  birthdate: DS.attr 'isodate'
  birthnumber: DS.attr 'string'
  birthplace: DS.attr 'string'
  nationality: DS.attr 'string'
  occupation: DS.attr 'string'
  emergency_name: DS.attr 'string'
  emergency_day: DS.attr 'string'
  emergency_night: DS.attr 'string'
  special_needs: DS.attr 'string'
  past_experience: DS.attr 'string'
  comments: DS.attr 'string'
  fax: DS.attr 'string'
  street: DS.attr 'string'
  city: DS.attr 'string'
  zipcode: DS.attr 'string'
  contact_street: DS.attr 'string'
  contact_city: DS.attr 'string'
  contact_zipcode: DS.attr 'string'
  note: DS.attr 'string'
  account: DS.attr 'string'

  name: (->
    first = @get('firstname')
    last = @get('lastname')
    "#{last} #{first}"
    ).property('firstname', 'lastname')


  for_email: ->
    @_super('name')

})
