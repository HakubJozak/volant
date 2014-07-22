Ember.Handlebars.helper 'free-places', (wc) ->
  new Handlebars.SafeString """
      #{wc.get('free_places')}/
      <b>♀</b>#{wc.get('free_places_for_females')}/
      <b>♂</b>#{wc.get('free_places_for_males')}
  """
