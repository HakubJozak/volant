Volant.ApplyForm = DS.Model.extend Volant.PersonalAttributesMixin, 
  type: DS.attr 'string'

  current_workcamp:  DS.belongsTo 'workcamp', async: true
  current_assignment:  DS.belongsTo 'workcamp_assignment', async: true
  current_message: DS.belongsTo 'message',async: true, inverse: null
  state: DS.attr 'state'

  tags: DS.hasMany('tag',embedded: 'always')
  workcamp_assignments:  DS.hasMany 'workcamp_assignment', async: true, inverse: 'apply_form'
  volunteer:  DS.belongsTo 'volunteer'
  payment:  DS.belongsTo 'payment'


  confirmed: DS.attr 'isodate'
  createdAt: DS.attr 'isodate'
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'

  # server side flags
  starred: DS.attr 'boolean'
  noResponseAlert: DS.attr 'boolean'
  missingInfosheetAlert: DS.attr 'boolean'
  hasAlert: Ember.computed.or('noResponseAlert','missingInfosheetAlert')
  createdRecently: (-> moment().diff(@get('createdAt'),'day') < 2 ).property('createdAt')

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
    
