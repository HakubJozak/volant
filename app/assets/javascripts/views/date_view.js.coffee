Volant.DateView = Ember.View.extend
  formatted_model: ( ->
    date = @get('model')
    moment(date).format('YYYY-MM-DD')
   ).property('model')
