Volant.ApplyFormView = Ember.View.extend Volant.SavingShortcutsMixin,
  templateName: 'apply_form'

  anchor: Ember.computed.alias('controller.anchor')

  didInsertElement: ( ->
    if a = @get('anchor')
      @set('anchor',null)  
      if offset = $("##{a}").offset()
        $('body').scrollTop(offset.top - 50)
  ).observes('anchor')
