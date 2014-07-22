Volant.DateView = Volant.FieldView.extend
  templateName: 'inputs/date'
  formatted_model: ( ->
    date = @get('model')
    moment(date).format('YYYY-MM-DD')
   ).property('attr')
