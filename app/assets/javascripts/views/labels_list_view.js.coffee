Volant.LabelsListView = Ember.CollectionView.extend
  tagName: 'ul'
  classNames: ['labels-list']

  actions:
    remove: (tag) ->
      if action = @get('removeAction')  
        @get('controller').send(action,tag)
      else
        @get('content').removeObject(tag)


  itemViewClass: Ember.View.extend({
    templateName: 'label'
  })

