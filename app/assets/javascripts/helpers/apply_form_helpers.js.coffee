Ember.Handlebars.helper 'csv-download-link', (base) ->
  year = @get('year')
  new Handlebars.SafeString """
    <a href="#{base}?year=#{year}" title="Download CSV for #{year}">
       <i class='fa fa-download'></i> CSV
    </a>
   """



Ember.Handlebars.helper 'apply-form-state-icon', (state) ->
  if state?
    key = if typeof state isnt 'string'
            info = state.get('info')
            state.get('name').toLowerCase()
          else
            info = state
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

  new Handlebars.SafeString "<i title='#{info}' class='fa fa-#{icon} #{key}'></i>"



Ember.Handlebars.helper 'apply-form-action-icon', (name) ->

  icons = {
    accept: 'thumbs-o-up'
    reject: 'thumbs-o-down'
    ask: 'envelope-o'
    infosheet: 'suitcase'
    pay: 'money'
    email: 'envelope-o'
    cancel: 'times'
  }
  icon = "<i class='fa fa-#{icons[name]}'></i>"
  new Handlebars.SafeString(icon)
