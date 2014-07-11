# for more details see: http://emberjs.com/guides/views/

Volant.FieldView = Ember.View.extend
  templateName: 'field'
  classNames: [ 'pure-control-group']

  input_type: 'text'
  use_textarea: false

  value: ( ->
    @get("context.model.#{@get('attr')}")
   ).property('attr')


Volant.TextareaView = Volant.FieldView.extend
  use_textarea: true


Volant.DateView = Volant.FieldView.extend
  input_type: 'date'
  value: ( ->
    date = @_super()
    moment(date).format('YYYY-MM-DD')
   ).property('attr')
