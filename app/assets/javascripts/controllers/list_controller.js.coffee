Volant.ListController = Ember.ArrayController.extend Volant.ModeAwareMixin,

  needs: ['application','pagination']
  year: Ember.computed.alias('controllers.application.year')
  pagination: Ember.computed.alias('controllers.pagination')

  sortAscending: false
  sortAscendingOptions: [ {name:'Ascending', id: true },{ name:'Descending', id: false }]

  # automatic refresh on year selection
  yearObserver: ( ->
    Ember.run.once(this,'send','yearChanged');
  ).observes('year')

  actions:
    search: ->
      @set('page',1)
      true

    downloadCsv: ->
      total = @get('pagination.total')
      if total > 500
        return unless confirm("The number of records you wish to \
                               export (#{total}) is too big and it may choke the server
                               or timeout before you download any date. \
                               Do you wish to proceed?")
      window.location = @store.typeMapFor(@get('targetModel')).metadata.csv
      false
            

      
