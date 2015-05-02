Volant.NewMessageRoute = Volant.MessageRoute.extend
  templateName: 'message'
  controllerName: 'message'

  afterSave: (record) ->
    @transitionTo 'message',record
    @flash_info 'Message saved.'

  model: (params) ->
    action_name = if params.action_name == 'email'
                    null
                  else
                    params.action_name

    @store.find('user',@get('current_user.content.id')).then (user) =>
      @store.find('apply_form',params.apply_form_id).then (form) =>
        form.get('current_workcamp').then (workcamp) =>

        msg = @store.createRecord 'message', {
          action: action_name
          apply_form: form
          user: user
        }

        if action_name == 'ask'
          html = @store.createRecord 'attachment',{ type: 'VefHtmlAttachment', applyForm: form }
          pdf = @store.createRecord 'attachment',{ type: 'VefPdfAttachment', applyForm: form }
          xml = @store.createRecord 'attachment',{ type: 'VefXmlAttachment', applyForm: form }
          msg.get('attachments').pushObject(html)
          msg.get('attachments').pushObject(pdf)
          msg.get('attachments').pushObject(xml)
        msg
