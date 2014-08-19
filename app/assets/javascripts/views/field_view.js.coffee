Volant.FieldView = Ember.View.extend
  classNameBindings: [ 'errors:has-error']
  width: 10
  lwidth: 1

  labelClass: ( ->
   "col-lg-#{@get('lwidth')}"
   ).property('offset')

  inputClass: ( ->
   "col-lg-#{@get('width')}"
   ).property('width')

  errorsOffsetClass: ( ->
   "col-lg-offset-#{@get('lwidth')}"
   ).property('width')
