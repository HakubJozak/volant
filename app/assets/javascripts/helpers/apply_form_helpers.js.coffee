Ember.Handlebars.helper 'apply-form-state-icon', (state) ->
  key = if state? then state.get('name').toLowerCase() else ''
  icon = switch key
           when "accepted" then 'thumbs-up'
           when "rejected" then 'thumbs-down'
           when "asked" then 'envelope-o'
           when "paid" then 'money'
           when "not_paid" then 'circle-o'
           when "infosheeted" then 'suitcase'
           when "cancelled" then 'times-circle-o'
           else ''

  new Handlebars.SafeString "<i title='#{state.info}' class='fa fa-#{icon} #{state}'></i>"

Ember.Handlebars.helper 'apply-form-action', (name) ->
  [clazz,icon] = switch name
                   when 'accept' then [ 'btn-success', 'thumbs-up' ]
                   when 'reject' then [ 'btn-danger', 'thumbs-down' ]
                   when "ask" then [ '','envelope-o' ]
                   when "infosheet" then ['','suitcase']

  icon = "<i class='fa fa-#{icon} #{name}'></i>"
  button = "<button type='button' class='btn btn-sm #{clazz}'>#{icon}</button>"

  new Handlebars.SafeString(button)
