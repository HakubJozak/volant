Volant.MessageSerializer = Volant.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    attachments: { serialize: 'records', deserialize: 'ids' }
