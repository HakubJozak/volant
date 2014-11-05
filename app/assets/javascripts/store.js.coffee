# http://emberjs.com/guides/models/#toc_store
# http://emberjs.com/guides/models/pushing-records-into-the-store/

Volant.ApplicationStore = DS.Store.extend({

})

# Override the default adapter with the `DS.ActiveModelAdapter` which
# is built to work nicely with the ActiveModel::Serializers gem.
Volant.ApplicationAdapter = DS.ActiveModelAdapter.extend({
})


Volant.ApplicationSerializer = DS.ActiveModelSerializer

Volant.ApplyFormSerializer = DS.ActiveModelSerializer.extend({
  serialize: (apply_form,opts) ->
    json = @_super(apply_form,opts)


  serializeBelongsTo: (record, json, relationship) ->
    if relationship.key == 'payment'
      if payment = record.get('payment')
        json['payment_attributes'] = @serialize(payment,includeId: true)
      console.log json
      json
    else
      @_super(record,json,relationship)
})



# Transforms Date to avoid miss-match with rails date
Volant.IsodateTransform  = DS.DateTransform.extend({
  serialize: (date) ->
    if date then moment(date).format("YYYY-MM-DD") else null
})


Volant.StateTransform = DS.Transform.extend({
  serialize: (deserialized) ->
    deserialized.get('name')

  deserialize: (hash) ->
    Ember.Object.create(name: hash.name, info: hash.info, actions: hash.actions)
})

DS.Model.reopen({
  # Creates plain old JS object with all the Ember attributes
  # and selected `properties` accessible via plain old JS notation.
  #
  for_email: (properties...) ->
    result = {}
    @eachAttribute (attr) =>
      result[attr] = @get(attr)

    for prop in properties
      result[prop] = @get(prop)

    result

})
