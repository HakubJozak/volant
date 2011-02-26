class Outgoing::VolunteersController < ::PeopleController

  active_scaffold :volunteers do |config|
    config.columns << [ :nationality, :occupation, :account, :taggings ]

    group config, 'emergency', :emergency_name, :emergency_day, :emergency_night
    group config, 'languages', :speak_well, :speak_some
    group config, 'comments', :special_needs, :past_experience, :comments

    ban_editing config, :apply_forms
    config.list.columns << :apply_forms

    highlight_required(config, Volunteer)
  end

  def conditions_for_collection
    Volunteer.with_birthdays_conditions if params[:birthdays]
  end
end
