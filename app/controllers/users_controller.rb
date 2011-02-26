class UsersController < ApplicationController

  active_scaffold :users do |config|
    config.columns = [:firstname, :lastname,:login, :locale, :password, :password_confirmation, :email]
    list.columns = [:firstname, :lastname, :login, :email, :locale ]
    config.show.columns = [:login, :email, :created_at, :updated_at ]
    config.columns[:password].required = true
    config.columns[:password_confirmation].required = true

    highlight_required(config, User)
  end

end
