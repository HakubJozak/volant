# ♂ ♀
Ember.Handlebars.helper 'gender-sign', (gender) ->
  text = if gender == 'f'
           "<span title='Female'><i class='fa fa-fw fa-venus'></i></span>"
         else if gender == 'm'
           "<span title='Male'><i class='fa fa-fw fa-mars'></i></span>"
         else
           ''
  new Handlebars.SafeString(text)
