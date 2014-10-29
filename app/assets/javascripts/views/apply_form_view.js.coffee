Volant.ApplyFormView = Ember.View.extend
  templateName: 'apply_form'

  anchor: Ember.computed.alias('controller.anchor')

  didInsertElement: ->
    if a = @get('controller.anchor')
      $('body').scrollTop($("##{a}").offset().top - 50)
