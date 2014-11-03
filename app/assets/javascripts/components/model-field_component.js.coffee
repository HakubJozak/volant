Volant.ModelFieldComponent = Ember.Component.extend({
  # attributeBindings: ['data-toggle', 'data-placement']

  # dataToggle: 'tooltip'
  # dataPlacement: 'bottom'

  didInsertElement: ->

  update_info: (->
    controls = @$('input,select')

    if e = @get('errors')
      msg = "#{e[0].attribute} #{e[0].message}"
      controls.data('toggle','tooltip').data('placement','bottom').attr('title',msg).tooltip()
    else
      controls.tooltip('disable')

  ).observes('errors')


})
