Volant.AjaxToStoreMixin = Ember.Mixin.create
  ajax_to_store: (url,data = {}) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')
      data.authenticity_token = csrf_token

      try
        $.post url, data, (response) =>
          console.info 'Payload', response
          @store.pushPayload(response)
          resolve(response)
      catch e
        reject(e)
