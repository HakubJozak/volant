Ember.Handlebars.helper 'from-now', (date) ->
  moment(date).fromNow()

Ember.Handlebars.helper 'format-date', (date) ->
  moment(date).format('L')

Ember.Handlebars.helper 'long-date', (date) ->
  if date
    moment(date).format('LL')
  else
    '-'

Ember.Handlebars.helper 'word-date', (date) ->
  moment(date).format('MMMM Do YYYY')
