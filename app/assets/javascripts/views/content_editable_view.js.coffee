Ember.ContentEditableView = Em.View.extend
  tagName: "div"
  attributeBindings: ["contenteditable"]
  classNames: ['native-editor']

  # Variables:
  editable: true
  isUserTyping: false
  plaintext: false

  # Properties:
  contenteditable: (->
    editable = @get("editable")
    (if editable then "true" else `undefined`)
  ).property("editable")

  # Processors:
  processValue: ->
    @setContent() if not @get("isUserTyping") and @get("value")

  # Observers:
  valueObserver: (->
    Ember.run.once this, "processValue"
    return
  ).observes("value", "isUserTyping")

  # Events:
  didInsertElement: ->
    @setContent()

  focusOut: ->
    @set "isUserTyping", false

  keyDown: (event) ->
    @set "isUserTyping", true unless event.metaKey

  keyUp: (event) ->
    if @get("plaintext")
      @set "value", @$().text()
    else
      @set "value", @$().html()


  #render our own html so there are no metamorphs to get screwed up when the user changes the html
  render: (buffer) ->
    buffer.push @get("value")
    return

  setContent: ->
#    content = Ember.Handlebars.Utils.escapeExpression(@get("value"))
    content = @get("value")
    @$().html(content)
