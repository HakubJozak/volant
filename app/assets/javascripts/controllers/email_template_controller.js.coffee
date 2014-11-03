# for more details see: http://emberjs.com/guides/controllers/

Volant.EmailTemplateController = Volant.ObjectController.extend({
  after_save_route: 'email_templates'
})
