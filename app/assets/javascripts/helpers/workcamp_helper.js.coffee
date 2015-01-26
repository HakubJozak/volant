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

