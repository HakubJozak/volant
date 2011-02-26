class EmailTemplatesController < ApplicationController
  active_scaffold :email_templates do |config|
    config.list.columns = [ :action, :description ]
    config.columns = [ :action, :subject, :body ]
    config.columns[:subject].description = "__<a href='/email_templates/howto'>#{I18n.translate('txt.howto_templates')}</a>"

    config.update.columns = [  :wrap_into_template, :subject, :body ]
    config.actions.exclude :create, :delete
  end

  def howto
  end
end
