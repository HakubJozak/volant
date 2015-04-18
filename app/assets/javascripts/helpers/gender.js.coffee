Ember.Handlebars.helper 'gender-sign', (gender) ->
  text = if gender == 'f'
           "<span title='Female'>♀</span>"
         else if gender == 'm'
           "<span title='Male'>♂</span>"
         else
           ''
  new Handlebars.SafeString(text)
