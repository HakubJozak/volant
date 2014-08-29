Volant.SmallFlashView = Ember.View.extend
  elementName: 'p'
  classNameBindings: [ ':navbar-text' ]
  templateName: 'small_flash'

  type: (->
    switch @get('flash.type')
      when 'error' then 'text-danger'
      else 'text-success'
    ).property('flash.type')
