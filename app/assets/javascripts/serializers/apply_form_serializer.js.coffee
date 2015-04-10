Volant.ApplyFormSerializer = Volant.ApplicationSerializer.extend
  serializeIntoHash: (data, type, record,options) ->
    result = @_super(data,type,record,options)

    if id = record.get('workcampToAssignId')
      data.apply_form.workcamp_ids = [ id ]

    result


  serializeBelongsTo: (record, json, relationship) ->
    if relationship.key == 'payment'
      if payment = record.get('payment')
        json['payment_attributes'] = @serialize(payment,includeId: true)

      if volunteer = record.get('volunteer')
        json['volunteer_attributes'] = @serialize(volunteer,includeId: true)

      json
    else
      @_super(record,json,relationship)
