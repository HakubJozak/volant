Volant.Attachment = DS.Model.extend
  url: DS.attr 'string'
  filename: DS.attr 'string'
  message: DS.belongsTo 'message'
