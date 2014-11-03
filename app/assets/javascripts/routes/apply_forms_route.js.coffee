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


    open_existing_message: (message) ->
      @transitionTo('message',message)
      false

    search: ->
      @refresh()
      false

    refresh: ->
      @refresh()
      false

  open_message_for: (action_name,apply_form) ->
    @store.find('email_template').then (templates) =>
      @controllerFor('email_templates').set('content', templates)
      tmpl = templates.findBy('action',action_name)

      @store.find('user',@get('current_user.content.id')).then (user) =>
        message = @store.createRecord 'message', {
          from: user.get('email')
          to: apply_form.get('email')
          bcc: user.get('email')
#          to: apply_form.get('current_workcamp.organization.outgoing_email')
          action: action_name
          apply_form: apply_form
          user: user
          email_template: tmpl
        }

        message.save().then (msg) =>
          @transitionTo('message',msg)

    false

})
