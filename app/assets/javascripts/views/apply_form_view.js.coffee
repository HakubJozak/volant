Volant.ApplyFormView = Ember.View.extend
  templateName: 'apply_form'

  anchor: Ember.computed.alias('controller.anchor')

  didInsertElement: ( ->
    if a = @get('anchor')
      if offset = $("##{a}").offset()
        $('body').scrollTop(offset.top - 50)
  ).observes('anchor')
