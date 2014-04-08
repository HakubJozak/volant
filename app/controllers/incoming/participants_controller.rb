require "#{RAILS_ROOT}/app/models/incoming/participant"

class Incoming::ParticipantsController < ::ApplicationController
  helper 'incoming/participants'

  before_filter :find_participant, :only => [ :confirm, :cancel ]

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
                      :phone,
                      :birthdate,
                      :general_remarks,
                      :motivation
                     ]

    config.list.per_page = 9999
    config.list.columns = [ :status, :gender_in_list, :country, :lastname, :firstname, :incoming_organization, :age, :tags, :workcamp ]

    group config, 'address', :street, :city, :zipcode
    group config, 'contact_address', :contact_street, :contact_city, :contact_zipcode, :collapsed => true
    group config, 'emergency', :emergency_name, :emergency_day, :emergency_night, :collapsed => true
    group config, 'languages', :speak_well, :speak_some, :collapsed => true
    group config, 'details', :special_needs, :past_experience, :general_remarks, :motivation, :collapsed => true
    group config, 'comments', :taggings, :note

    config.action_links.add :confirm, :label => help.icon('confirm', ApplyForm.human_attribute_name("toggle_confirmed"), true), :type => :record,
                            :inline => false, :method => :post, :position => :replace

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

  def confirm
    @participant.toggle_confirmed
    redirect_to :back
  end

  def cancel
    @participant.toggle_cancelled
    redirect_to :back
  end

  private

  def find_participant
    @participant = Incoming::Participant.find(params[:id])
  end

end
