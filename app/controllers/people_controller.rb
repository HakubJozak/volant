class PeopleController < ApplicationController

  active_scaffold :person do |config|
    config.list.sorting = { :lastname => 'ASC', :firstname => 'ASC' }
    config.list.columns = [ :gender_in_list, :lastname, :firstname, :email, :phone, :age, :tags ]

    config.columns = [
                      :firstname, :lastname, :gender, :gender_in_list,
                      :email, :phone, :fax,
                      :birthdate,
                      :birthnumber, :age,
                      :taggings
                     ]

    group config, 'address', :street, :city, :zipcode
    group config, 'contact_address', :contact_street, :contact_city, :contact_zipcode

    ban_editing config, :gender_in_list, :age
    config.columns[:gender_in_list].sort = { :sql => 'gender' }
    config.columns[:age].sort = { :sql => 'birthdate'}
    config.list.sorting = { :lastname => 'ASC', :firstname => 'ASC' }

    highlight_required(config, Person)
  end


end
