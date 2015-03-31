Volant.ApplicationStore = DS.Store.extend()


# Transforms Date to avoid miss-match with rails date
Volant.IsodateTransform  = DS.DateTransform.extend
  serialize: (date) ->
    if date then moment(date).format("YYYY-MM-DD") else null


Volant.StateTransform = DS.Transform.extend
  serialize: (deserialized) ->
    # we do not send state tot the server
    null

  deserialize: (hash) ->
    Ember.Object.create(name: hash.name, info: hash.info, actions: hash.actions)


Volant.FileTransform = DS.Transform.extend
  serialize: (jsonData) ->
    jsonData

  deserialize: (externalData) ->
    externalData


DS.Model.reopen
  # Creates plain old JS object with all the Ember attributes
  # and selected `properties` accessible via plain old JS notation.
  #
  for_email: (properties...) ->
    hash = {}
    @eachAttribute (attr) =>
      hash[attr] = @get(attr)

    for prop in properties
      hash[prop] = @get(prop)

    if tags = @get('tags')
      hash.tags = {}
      tags.forEach (tag) ->
        hash.tags[tag.get('name')] = true

    hash
