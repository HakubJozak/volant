Volant.ApplyFormsRoute = Volant.BaseRoute.extend(Volant.MessagingRouteMixin,{
  model: (params) ->
    @store.find('apply_form', { p: params.page, year: params.year, q: params.query })

  title: -> "Applications"

  renderTemplate: ->
    @render('apply_forms')

  actions:
    apply_form_action: (action_name,form) ->
      @open_message_for action_name,form

    search: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false


})
