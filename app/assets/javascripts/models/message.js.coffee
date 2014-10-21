# for more details see: http://emberjs.com/guides/models/defining-models/

Volant.Message = DS.Model.extend
  to: DS.attr 'string'
  from: DS.attr 'string'
  subject: DS.attr 'string'
  body: DS.attr 'string'
  userId: DS.attr 'number'
  sentAt: DS.attr 'date'
  action: DS.attr 'string'
  emailTemplateId: DS.attr 'number'
  workcampAssignmentId: DS.attr 'number'
