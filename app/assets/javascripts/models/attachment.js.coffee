Volant.Attachment = DS.Model.extend
  type: DS.attr 'string'
  url: DS.attr 'string'
  filename: DS.attr 'string'
  message: DS.belongsTo 'message'

  applyForm: DS.belongsTo 'apply_form', async: true
  workcamp: DS.belongsTo 'workcamp', async: true

  name: (->
    @get('filename') ||
      switch @get 'type'
        when 'VefXmlAttachment' then 'VEF.xml'
        when 'VefPdfAttachment' then 'VEF.pdf'
        when 'VefHtmlAttachment' then 'VEF.html'
        else @get('filename')
  ).property('filename','type')


Volant.AttachmentSerializer = Volant.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    workcamp: { serialize: 'id', deserialize: 'id' }
    applyForm: { serialize: 'id', deserialize: 'id' }



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
