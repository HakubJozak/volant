Volant.SavingShortcutsMixin = Ember.Mixin.create
  keyDown: (e) ->
    if (e.ctrlKey || e.metaKey) && @_pressedKey(e) == 's'
      @get('controller').send('saveOnly')
      e.preventDefault()
      false

  # keyPress: (e) ->
  #   if e.keyCode == 13 && e.target.nodeName == 'INPUT'
  #     @get('controller').send('save')

  _pressedKey: (event) ->
    String.fromCharCode(event.which).toLowerCase()
