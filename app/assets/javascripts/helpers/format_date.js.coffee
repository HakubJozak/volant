Ember.Handlebars.helper 'from-now', (date) ->
  if date?
    moment(date).fromNow()
  else
    '-'

Ember.Handlebars.helper 'format-date', (date) ->
  if date?
    moment(date).format('L')
  else
    '-'

Ember.Handlebars.helper 'long-date', (date) ->
  if date?
    moment(date).format('LL')
  else
    '-'

Ember.Handlebars.helper 'word-date', (date) ->
  moment(date).format('MMMM Do YYYY')
