Ember.Handlebars.helper 'gender-sign', (gender) ->
  if gender == 'f'
    '♀'
  else if gender == 'm'
    '♂'
  else
    ''
