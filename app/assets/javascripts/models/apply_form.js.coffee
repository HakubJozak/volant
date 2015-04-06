Volant.ApplyForm = DS.Model.extend Volant.PersonalAttributesMixin, 
  type: DS.attr 'string'
  state: DS.attr 'state'

  country: DS.belongsTo('country')
  volunteer:  DS.belongsTo 'volunteer'
  payment:  DS.belongsTo 'payment'
  tags: DS.hasMany('tag',embedded: 'always')

  currentWorkcamp:  DS.belongsTo 'workcamp', async: true
  currentAssignment:  DS.belongsTo 'workcamp_assignment', async: true
  currentMessage: DS.belongsTo 'message',async: true, inverse: null
  workcampAssignments:  DS.hasMany 'workcamp_assignment', async: true, inverse: 'applyForm'

  confirmed: DS.attr 'isodate'
  createdAt: DS.attr 'isodate'
  updatedAt: DS.attr 'isodate'  
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  generalRemarks: DS.attr 'string'
  motivation: DS.attr 'string'

  # server side flags
  starred: DS.attr 'boolean'
  noResponseAlert: DS.attr 'boolean'
  missingInfosheetAlert: DS.attr 'boolean'
  hasAlert: Ember.computed.or('noResponseAlert','missingInfosheetAlert')
  createdRecently: (-> moment().diff(@get('createdAt'),'day') < 2 ).property('createdAt')

  # legacy fallbacks      
  current_workcamp:  Ember.computed.alias('currentWorkcamp')
  current_assignment: Ember.computed.alias('currentAssignment')
  current_message: Ember.computed.alias('currentMessage')
  general_remarks: Ember.computed.alias('generalRemarks')
  workcamp_assignments: Ember.computed.alias('workcampAssignments')        

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
    @get('workcampAssignments').any (wa) ->
      wa.get('workcamp.id') == wc.get('id')
    
