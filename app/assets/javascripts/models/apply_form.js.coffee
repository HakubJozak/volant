Volant.ApplyForm = DS.Model.extend
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

  name: Ember.computed.alias('volunteer.name')
  email: Ember.computed.alias('volunteer.email')
  createdToday: (-> moment().isSame(@get('createdAt'),'day')  ).property('createdAt')

  male: Ember.computed.alias('volunteer.male')
  female: Ember.computed.alias('volunteer.female')

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

  add_workcamp: (wc) ->
    console.info wc.id


Volant.ApplyFormAdapter = Volant.ApplicationAdapter.extend
  ajaxError: (jqXHR) ->
    if jqXHR && jqXHR.status == 422
      json = Ember.$.parseJSON(jqXHR.responseText)
      errors = json.errors

      for attr of errors
        # Set errors on the nested records, for example:
        #  { errors:
        #  { 'payment.amount': [ "must not be blank" ] }
        #  { 'payment.returned_date': [ "must not be blank" ] }
        #
        # becomes
        #
        # { 'payment': { amount: [ "must not be blank" ],
        #                returned_date: [ 'must not be blank' ] }
        # }
        #
        if match = attr.match(/([a-z_]+)\.([a-z_]+)/)
          association = match[1]
          innerAttribute = match[2]
          errors[association] ||= {}
          errors[association][innerAttribute] = errors[attr]

      invalid_error = new DS.InvalidError(errors)
      invalid_error.full_rails_message = json.full_message
      return invalid_error
    else
      return @_super(jqXHR)


Volant.ApplyFormSerializer = Volant.ApplicationSerializer.extend
  serializeBelongsTo: (record, json, relationship) ->
    if relationship.key == 'payment'
      if payment = record.get('payment')
        json['payment_attributes'] = @serialize(payment,includeId: true)

      if volunteer = record.get('volunteer')
        json['volunteer_attributes'] = @serialize(volunteer,includeId: true)

      json
    else
      @_super(record,json,relationship)
