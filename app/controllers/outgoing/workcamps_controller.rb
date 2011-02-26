class Outgoing::WorkcampsController < ::WorkcampsController
  
  active_scaffold 'Outgoing::Workcamp' do |config|
    config.columns << [ :tags, :apply_forms, :infosheets ]
    config.list.columns << [ :tags, :apply_forms, :infosheets ]

    config.columns[:apply_forms].includes = [ :workcamp_assignments ]
    #config.columns[:apply_forms].sort_by :sql => "workcamp_assignments.accepted"
    config.columns[:apply_forms].set_link('nested', :parameters => { :associations => :apply_forms })

    ban_editing :apply_forms
    highlight_required(config, Outgoing::Workcamp)
  end

  def do_new
    @record = Workcamp.new :country => Country.find_by_code('FR'),
                           :minimal_age => 18,
                           :maximal_age => 99,
                           :language => 'English',
                           :places => 2,
                           :places_for_males => 2,
                           :places_for_females => 2
  end

end
