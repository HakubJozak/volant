Volant.ApplyFormsRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,

  queryParams:
    order: { refreshModel: true }
    sortAscending: { refreshModel: true }
    state: { refreshModel: true }    

  model: (params) ->
    @store.find('apply_form', {
      p: params.page
      year: params.year
      q: params.query
      order: params.order      
      state: params.state
      asc: params.sortAscending
    })

  title: -> "Applications"

  renderTemplate: ->
    @render('apply_forms')

  actions:
    remove: (record) ->
      return unless confirm("Really delete #{record.get('name')}")  
      record.destroyRecord().then (=>
        @flash_info 'Deleted.'
      ), ( (e) =>
        console.error e
        @flash_error "Failed."
      )
      false

    pay: (form) ->
      @transitionTo('apply_form',form,{ queryParams: { anchor: 'payment-fields'}})

    search: ->
      @refresh()
      false

    yearChanged: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false
