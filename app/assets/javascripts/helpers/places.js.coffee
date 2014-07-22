Ember.Handlebars.helper 'format-places', (wc) ->
  new Handlebars.SafeString """
      #{wc.get('places')}/
      <b>♀</b>#{wc.get('places_for_females')}/
      <b>♂</b>#{wc.get('places_for_males')}
  """
