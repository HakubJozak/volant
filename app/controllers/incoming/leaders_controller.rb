class Incoming::LeadersController < PeopleController
  active_scaffold 'Incoming::Leader' do |config|
    config.list.columns = [ :gender_in_list, :lastname, :firstname, :email, :phone, :age, :tags, :workcamps ]
    highlight_required(config, Incoming::Leader)
  end
end
