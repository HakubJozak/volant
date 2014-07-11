# for more details see: http://emberjs.com/guides/views/

Volant.FieldView = Ember.View.extend
  templateName: 'field'
  classNames: [ 'pure-control-group']
  input_type: 'text'
  value: ( ->
    @get("context.model.#{@get('attr')}")
   ).property('attr')


Volant.DateView = Volant.FieldView.extend
  input_type: 'date'
  value: ( ->
    date = @_super()
    moment(date).format('YYYY-MM-DD')
   ).property('attr')
