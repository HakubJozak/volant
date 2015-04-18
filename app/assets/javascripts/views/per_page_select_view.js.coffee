Volant.PerPageSelectView = Ember.Select.extend
  content: [10,15,25,50]
  classNames: ["form-control"]

  change: ->
    @get('controller').send('search')
    false

