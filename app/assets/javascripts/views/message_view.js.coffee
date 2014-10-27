Volant.MessageView = Ember.View.extend
  templateName: 'message'

Volant.TextArea = Ember.TextArea.extend({
  didInsertElement: ->
    # @$('textarea').autosize()
    $('#' + @get('elementId')).autogrow()
});
