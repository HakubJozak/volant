Volant.ApplyFormsRoute = Volant.BaseRoute.extend Volant.ApplyFormActions,
  # queryParams: {
  #    sortProperties: { refreshModel: true },
  #    sortAscending: { refreshModel: true }
  # }

  model: (params) ->
    @store.find('apply_form', {
      p: params.page
      year: params.year
      q: params.query
      state: params.state
#      sort: params.sortProperties
#      asc: params.sortAscending
    })

  title: -> "Applications"

  renderTemplate: ->
    @render('apply_forms')

  actions:
    pay: ->
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
