require "#{RAILS_ROOT}/app/models/incoming/participant"

class Incoming::ParticipantsController < ::ApplicationController
  helper 'incoming/participants'

  active_scaffold 'Incoming::Participant' do |config|
    config.columns = [
                      :status,
                      :country,
                      :organization,
                      :nationality,
                      :gender,
                      :firstname, 
                      :lastname,
                      :workcamp,
                      :email,
                      :birthdate,
                      :general_remarks,
                      :motivation
                     ]

    config.list.columns = [ :status, :gender_in_list, :country, :lastname, :firstname, :incoming_organization, :age, :tags, :workcamp ]
    group config, 'address', :street, :city, :zipcode
    group config, 'contact_address', :contact_street, :contact_city, :contact_zipcode, :collapsed => true
    group config, 'emergency', :emergency_name, :emergency_day, :emergency_night, :collapsed => true
    group config, 'languages', :speak_well, :speak_some, :collapsed => true
    group config, 'details', :special_needs, :past_experience, :general_remarks, :motivation, :collapsed => true
    group config, 'comments', :taggings, :note

    config.action_links.add :cancel, :label => help.icon('cancel', ApplyForm.human_attribute_name("toggle_cancel"), true), :type => :record, 
                            :inline => false, :method => :post, :position => :replace

    setup_country_field(config)
    config.columns[:organization].form_ui = :select
    config.columns[:general_remarks].form_ui = :textarea
    config.columns[:motivation].form_ui = :textarea
    config.columns[:status].label = ''
    highlight_required(config, Incoming::Participant)

    ban_editing config, :workcamp, :status, :general_remarks, :motivation
  end

  def active_scaffold_per_request_config
    super

    if nested?
      active_scaffold_config.action_links.add(:new)       
    else
      active_scaffold_config.action_links.delete(:new) 
    end
  end
  
  def cancel
    @participant = Incoming::Participant.find(params[:id])
    @participant.toggle_cancelled
    redirect_to :back
  end

end
