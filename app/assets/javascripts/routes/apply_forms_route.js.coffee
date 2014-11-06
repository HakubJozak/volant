Volant.ApplyFormsRoute = Volant.BaseRoute.extend({
  # queryParams: {
  #    sortProperties: { refreshModel: true },
  #    sortAscending: { refreshModel: true }
  # }

  model: (params) ->
    @store.find('apply_form', {
      p: params.page
      year: params.year
      q: params.query
#      sort: params.sortProperties
#      asc: params.sortAscending
    })

  title: -> "Applications"

  renderTemplate: ->
    @render('apply_forms')

  actions:
    apply_form_action: (action,form) ->
      switch action
        when 'pay'
          @transitionTo('apply_form',form,{ queryParams: { anchor: 'payment-fields'}})
        when 'cancel'
          url = "/apply_forms/#{form.get('id')}/cancel"
          @ajax_to_store(url).then (payload) =>
            @flash_info 'Application cancelled.'

        else
          @open_message_for action,form

    search: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false

})
