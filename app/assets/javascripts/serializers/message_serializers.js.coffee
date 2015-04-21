Volant.MessageSerializer = Volant.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    attachments: { serialize: 'records', deserialize: 'ids' }


Volant.WorkcampSerializer = Volant.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    bookings: { serialize: 'ids', deserialize: 'ids' }
