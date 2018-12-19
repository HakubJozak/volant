Barbecue.BsTabsView = Ember.View.extend
  templateName: 'bs-tabs'

  tabList: (->
    @get('tabs').split(',').map (name) =>
      id = name.toLowerCase()
      selected = @get('currentTab') == id
      Ember.Object.create(title: name,id: id,selected: selected)
  ).property('tabs','currentTab')

  currentTabView: (-> @get('viewPrefix') + @get('currentTab')).property('currentTab','viewPrefix')

  actions:
    selectTab: (tab) ->
      @set 'currentTab',tab
