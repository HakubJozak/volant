Volant.DateView = Ember.View.extend
  templateName: 'date_view'
  formatted_model: ( ->
    date = @get('model')
    moment(date).format('YYYY-MM-DD')
   ).property('model')
