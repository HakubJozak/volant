Ember.Handlebars.helper 'format-date', (date) ->
  moment(date).format('L')

Ember.Handlebars.helper 'long-date', (date) ->
  if date
    moment(date).format('LL')
  else
    '-'
