Volant.ApplicationSerializer = DS.ActiveModelSerializer.extend
  serializeHasMany: (record, json, relationship) ->
    json_key = "#{relationship.key.singularize().underscore()}_ids"
    records = Ember.get(record, relationship.key)

    if records && relationship.options.embedded == 'always'
      json[json_key] = [];
      records.forEach (item,index) ->
        json[json_key].push(item.get('id'))
    else
      @_super(record,json.relationship)


