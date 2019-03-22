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
    order = ['confirmed', 'infosheeted', 'accepted', 'asked', 'paid', 'cancelled', 'rejected']
    priority = order.indexOf(hash.name)
    Ember.Object.create(name: hash.name, info: hash.info, actions: hash.actions, isState: true, priority: priority)


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
        escaped = tag.get('name').replace(/\./,'_').toLowerCase()
        hash.tags[escaped] = true

    if c = @get('country')
      region = parseInt(c.get('region'))

      hash.country = {}
      hash.country['name'] = c.get('name_en')  
      hash.country['is_region_1'] = (region == 1)
      hash.country['is_region_2'] = (region == 2)

      c.eachAttribute (attr) =>
        hash.country[attr] = c.get(attr)

    hash
