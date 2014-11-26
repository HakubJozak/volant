Volant.LabelsListView = Ember.CollectionView.extend({
  tagName: 'ul'
  classNames: ['labels-list']

  actions:
    remove: (tag) ->
      @get('content').removeObject(tag)

  itemViewClass: Ember.View.extend({
    templateName: 'label'
  })
})
