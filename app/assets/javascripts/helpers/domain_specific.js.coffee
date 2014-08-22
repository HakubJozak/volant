Ember.Handlebars.helper 'free-places', (wc) ->
  new Handlebars.SafeString """
      #{wc.get('free_places')}/
      <b>♀</b>#{wc.get('free_places_for_females')}/
      <b>♂</b>#{wc.get('free_places_for_males')}
  """

Ember.Handlebars.helper 'age-range', (wc) ->
  min = wc.get('minimal_age')
  max = wc.get('maximal_age')

  if min? and max?
    "#{min} - #{max}"
  else if min?
    "#{min} <"
  else if max?
    "< #{max}"
  else
    ''

Ember.Handlebars.helper 'gender', (volunteer) ->
  if volunteer.get('gender') == 'm'
    '♀'
  else
    '♂'
