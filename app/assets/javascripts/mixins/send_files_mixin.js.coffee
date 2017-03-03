Volant.SendFiles = Ember.Mixin.create
  send_files: (url,data) ->
    new Promise (resolve, reject) =>
      csrf_token = $('meta[name="csrf-token"]').attr('content')
      csrf_param = $('meta[name="csrf-param"]').attr('content')
      data.append('authenticity_token',csrf_token)

      $.ajax
        url: url
        type: "POST"
        success: (response) =>
          resolve(response)

        error: (error) =>
          reject(error)

        data: data
        cache: false
        contentType: false
        processData: false
