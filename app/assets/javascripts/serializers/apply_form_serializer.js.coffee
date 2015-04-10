Volant.ApplyFormSerializer = Volant.ApplicationSerializer.extend
  serializeIntoHash: (data, type, record,options) ->
    result = @_super(data,type,record,options)

    if wc = record.get('workcampToAssign')
      data.apply_form.workcamp_ids = [ wc.get('id') ]

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
