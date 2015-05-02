Ember.Handlebars.helper 'apply-form-alerts', (form) ->
  alerts = []      

  if form.get('noResponseAlert')
    alerts.push 'No response for more than 3 days.'

  if form.get('missingInfosheetAlert')
    alerts.push 'Infosheet missing.'

  console.info alerts

  unless Ember.empty(alerts)
    info = alerts.join(' ')    
    new Handlebars.SafeString("<i class='fa fa-bell alert' title='#{info}'></i>")
