Volant.Attachment = DS.Model.extend
  url: DS.attr 'string'
  filename: DS.attr 'string'
  message: DS.belongsTo 'message'
  name: Ember.computed.alias('filename')
#  file: DS.attr 'file'

# Volant.AttachmentAdapter = Volant.ApplicationAdapter.extend
#   # enables file upload
#   ajaxOptions: (url, type, hash) ->
#     hash = hash || {}
#     hash.url = url
#     hash.type = type
#     hash.dataType = 'json'
#     hash.context = @
#     typeIsArray = Array.isArray || (what) -> return {}.toString.call(what) is '[object Array]'

#     if hash.data and type != 'GET' and type != 'DELETE'
#       root = Object.keys(hash.data)[0]
#       fd = new FormData()
#       for key in Object.keys(hash.data[root])
#         value = hash.data[root][key]
#         fd.append("#{root}[#{key}]", value)

#       hash.data = fd
#       hash.processData = false
#       hash.contentType = false


#     headers = Ember.get(@, 'headers')
#     if headers != undefined
#       hash.beforeSend = (xhr) ->
#         for key in Ember.keys(headers)
#           xhr.setRequestHeader(key, headers[key])

#     hash
