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

Ember.Handlebars.helper 'workcamp-state-icon', (state) ->
  name = switch state
           when "accepted" then 'thumbs-up'   #'check-circle-o'
           when "rejected" then 'thumbs-down' # 'times-circle-o'
           when "asked" then 'envelope-o'
           when "paid" then ''
           when "infosheeted" then 'suitcase'
           when "cancelled" then 'times-circle-o'
           else ''
  new Handlebars.SafeString "<i title='#{state}' class='fa fa-#{name}'></i>"

Ember.Handlebars.helper 'apply-form-state-icon', (state) ->
  name = switch state
           when "accepted" then 'thumbs-up'
           when "rejected" then 'thumbs-down'
           when "asked" then 'envelope-o'
           when "paid" then 'money'
           when "not_paid" then 'circle-o'
           when "infosheeted" then 'suitcase'
           when "cancelled" then 'times-circle-o'
           else ''

  new Handlebars.SafeString "<i title='#{state}' class='fa fa-#{name}'></i>"


Ember.Handlebars.helper 'gender', (volunteer) ->
  # for unfullfilled promises
  return unless volunteer?

  if volunteer.get('gender') == 'f'
    '♀'
  else
    '♂'
