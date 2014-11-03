Ember.Handlebars.helper 'apply-form-state-icon', (state) ->
  key = if state?
          if typeof state isnt 'string'
            state.get('name').toLowerCase()
          else
            state

  icon = switch key
           when "accepted" then 'thumbs-o-up'
           when "rejected" then 'thumbs-o-down'
           when "asked" then 'envelope-o'
           when "paid" then 'money'
           when "not_paid" then 'circle-o'
           when "infosheeted" then 'suitcase'
           when "cancelled" then 'times-circle-o'
           else ''

  new Handlebars.SafeString "<i title='#{state.info}' class='fa fa-#{icon} #{key}'></i>"



Ember.Handlebars.helper 'apply-form-action-icon', (name) ->

  icons = {
    accept: 'thumbs-o-up'
    reject: 'thumbs-o-down'
    ask: 'envelope-o'
    infosheet: 'suitcase'
    pay: 'money'
    cancel: 'times'
  }
  icon = "<i class='fa fa-#{icons[name]}'></i>"
  new Handlebars.SafeString(icon)
