Volant.PerPageSelectView = Ember.Select.extend
  content: [10,15,25,50]
  classNames: ["form-control"]

  change: ->
    Volant.saveSettings 'perPage',@get('value')
    @get('controller').send('search')
    true

