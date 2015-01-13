Ember.Handlebars.helper 'from-now', (date) ->
  if date?
    moment(date).fromNow()
  else
    '?'

Ember.Handlebars.helper 'format-date', (date) ->
  if date?
    moment(date).format('L')
  else
   '?'

Ember.Handlebars.helper 'long-date', (date) ->
  if date?
    moment(date).format('LL')
  else
    '?'

Ember.Handlebars.helper 'word-date', (date) ->
  moment(date).format('MMMM Do YYYY')

Ember.Handlebars.helper 'dates', (wc) ->
  from = wc.get('begin')
  to = wc.get('end')
  year_from = if from? then from.getFullYear() else '?'
  year_to = if to? then to.getFullYear() else '?'

  if year_from == year_to
    fmt = 'D/M'
    text = "#{moment(from).format(fmt)} - #{moment(to).format(fmt)}, #{year_from}"
  else
    fmt = 'L'
    "#{moment(from).format(fmt)} - #{moment(to).format(fmt)}"


