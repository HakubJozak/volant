Volant.ApplyForm = DS.Model.extend Volant.VolunteerMixin, 
  type: DS.attr 'string'

  current_workcamp:  DS.belongsTo 'workcamp', async: true
  current_assignment:  DS.belongsTo 'workcamp_assignment', async: true
  current_message: DS.belongsTo 'message',async: true, inverse: null
  state: DS.attr 'state'

  tags: DS.hasMany('tag',embedded: 'always')
  workcamp_assignments:  DS.hasMany 'workcamp_assignment', async: true, inverse: 'apply_form'
  volunteer:  DS.belongsTo 'volunteer'
  payment:  DS.belongsTo 'payment'

  starred: DS.attr 'boolean'
  confirmed: DS.attr 'isodate'
  createdAt: DS.attr 'isodate'
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'

  noResponseAlert: DS.attr 'boolean'
  missingInfosheetAlert: DS.attr 'boolean'
  hasAlert: Ember.computed.or('noResponseAlert','missingInfosheetAlert')
  createdRecently: (-> moment().diff(@get('createdAt'),'day') < 2 ).property('createdAt')

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



  becameInvalid: ->
   @invalidate_association('volunteer')
   @invalidate_association('payment')

  becameValid: ->
    @get('payment.errors').clear()
    @get('volunteer.errors').clear()

  invalidate_association: (association) ->
    if @get(association)
      if @get('errors').has(association)
        nested_errors = @get('errors').errorsFor(association)
        inner = nested_errors[0].message

        for key of inner
          @get("#{association}.errors").add(key, inner[key])

  has_workcamp: (wc) ->
    @get('workcamp_assignments').any (wa) ->
      wa.get('workcamp.id') == wc.get('id')
    
