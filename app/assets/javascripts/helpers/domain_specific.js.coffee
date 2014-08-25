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

Ember.Handlebars.helper 'state-icon', (state) ->
  name = switch state
           when "accepted" then 'check-circle-o'
           when "rejected" then 'times-circle-o'
           when "asked" then 'envelope-o'
           when "paid" then 'circle-o'
           when "not_paid" then 'question-circle'
           when "infosheeted" then 'suitcase'
           else ''

  new Handlebars.SafeString "<i title='#{state}' class='fa fa-#{name}'></i>"


Ember.Handlebars.helper 'gender', (volunteer) ->
  # for unfullfilled promises
  return unless volunteer?

  if volunteer.get('gender') == 'f'
    '♀'
  else
    '♂'
