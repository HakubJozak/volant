Volant.FieldView = Ember.View.extend
  classNameBindings: [ ':form-group', 'errors:has-error']
  width: 11
  offset: 1

  labelClass: ( ->
   "col-lg-#{@get('offset')}"
   ).property('offset')

  inputClass: ( ->
   "col-lg-#{@get('width')}"
   ).property('width')

  inputOffsetClass: ( ->
   "col-lg-#{12 - @get('width')}"
   ).property('width')
