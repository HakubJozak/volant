class Outgoing::VolunteersController < ApplicationController

  active_scaffold :volunteers do |config|
    config.list.sorting = { :lastname => 'ASC', :firstname => 'ASC' }
    config.list.columns = [ :gender_in_list, :lastname, :firstname, :email, :phone, :age, :tags ]

    config.columns = [
                      :firstname, :lastname, :nationality, :occupation,
                      :gender, :gender_in_list,
                      :email, :phone, :fax,
                      :birthdate,
                      :birthnumber, :age,
                      :taggings
                     ]

    group config, 'address', :street, :city, :zipcode
    group config, 'contact_address', :contact_street, :contact_city, :contact_zipcode
    group config, 'emergency', :emergency_name, :emergency_day, :emergency_night
    group config, 'languages', :speak_well, :speak_some
    group config, 'comments', :special_needs, :past_experience, :comments

    ban_editing config, :gender_in_list, :age
    ban_editing config, :apply_forms

    config.columns[:gender_in_list].sort = { :sql => 'gender' }
    config.columns[:age].sort = { :sql => 'birthdate'}

    config.list.columns << :apply_forms
    config.list.sorting = { :lastname => 'ASC', :firstname => 'ASC' }

    highlight_required(config, Volunteer)
  end

  def conditions_for_collection
    Volunteer.with_birthdays_conditions if params[:birthdays]
  end
end
