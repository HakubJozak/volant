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
