Volant.NativeEditorComponent = Ember.Component.extend({
  editable: true

  actions:
    bold: ->
      document.execCommand('bold')
      false

    italic: ->
      document.execCommand('italic')
      false

    link: ->
      uri = 'http://'

      if window.getSelection
        if node = getSelection().anchorNode
          link = if node.nodeName == "#text"
                  node.parentNode
                else
                  node
          if $(link).is('a')
            uri = $(link).attr('href')
      else
        console.error 'Link editation is not supported by your browser.'

      chosen = window.prompt('URI',uri)
      if chosen?
        document.execCommand('createLink',true,chosen)
      false
    unorderedList: ->
      document.execCommand('insertUnorderedList')
      false
})
