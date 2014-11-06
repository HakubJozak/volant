Ember.Handlebars.helper 'dates', (wc) ->
  from = wc.get('begin')
  to = wc.get('end')
  year_from = if from? then from.getFullYear() else '?'
  year_to = if to? then to.getFullYear() else '?'

  if year_from == year_to
    fmt = 'MMMM Do'
    "#{moment(from).format(fmt)} - #{moment(to).format(fmt)}, #{year_from}"
  else
    fmt = 'MMMM Do YYYY'
    "#{moment(from).format(fmt)} - #{moment(to).format(fmt)}"


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

Ember.Handlebars.helper 'workcamp-state-icon', (state) ->
  name = switch state
           when "accepted" then 'thumbs-up'   #'check-circle-o'
           when "rejected" then 'thumbs-down' # 'times-circle-o'
           when "asked" then 'envelope-o'
           when "paid" then ''
           when "infosheeted" then 'suitcase'
           when "cancelled" then 'times-circle-o'
           else ''
  new Handlebars.SafeString "<i title='#{state}' class='fa fa-#{name} #{state}'></i>"




Ember.Handlebars.helper 'gender', (volunteer) ->
  # for unfullfilled promises
  return unless volunteer?

  if volunteer.get('gender') == 'f'
    '♀'
  else
    '♂'
