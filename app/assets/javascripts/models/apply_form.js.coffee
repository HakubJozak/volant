Volant.ApplyForm = DS.Model.extend({
  current_workcamp:  DS.belongsTo 'workcamp', async: true
  current_assignment:  DS.belongsTo 'workcamp_assignment', async: true
  message: DS.belongsTo 'message',async: true
  state: DS.attr 'state'

  workcamp_assignments:  DS.hasMany 'workcamp_assignment', async: true, inverse: 'apply_form'
  volunteer:  DS.belongsTo 'volunteer'
  payment:  DS.belongsTo 'payment'

  starred: DS.attr 'boolean'
  confirmed: DS.attr 'isodate'
  created_at: DS.attr 'isodate'
  cancelled: DS.attr 'isodate'
  fee: DS.attr 'number'
  general_remarks: DS.attr 'string'
  motivation: DS.attr 'string'

  name: Ember.computed.alias('volunteer.name')
  email: Ember.computed.alias('volunteer.email')

  becameInvalid: ->
   if volunteer = @get('volunteer')
     if @get('errors').has('volunteer')
       nested_errors = @get('errors').errorsFor('volunteer')
       inner = nested_errors[0].message

       for key of inner
         @get("volunteer.errors").add(key, inner[key])


   if payment = @get('payment')
     if @get('errors').has('payment')
       nested_errors = @get('errors').errorsFor('payment')
       inner = nested_errors[0].message

       for key of inner
         @get("payment.errors").add(key, inner[key])



  has_workcamp: (wc) ->
    @get('workcamp_assignments').any (wa) ->
      wa.get('workcamp.id') == wc.get('id')

  add_workcamp: (wc) ->
    console.info wc.id
})
