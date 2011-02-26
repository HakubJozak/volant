require "#{RAILS_ROOT}/app/models/outgoing/workcamp_assignment"
require "#{RAILS_ROOT}/app/models/outgoing/workcamp"


class RestfulApplyFormsController < RestfulController

  def create
    respond_to do |format|
      begin
        @apply_form = Outgoing::ApplyForm.create_from_hash!(params, current_user)
        format.xml  { render :xml => @apply_form, :status => :created, :location => @apply_form }
        logger.info "Created apply form #{@apply_form}"
      rescue Outgoing::ApplyForm::NoWorkcampError => error
        logger.warn 'No workcamps in the apply form'
      rescue Outgoing::ApplyForm::InvalidModelError => error
        logger.warn '#{error.model.class} not valid'
        format.xml  { render :xml => error.model.errors, :status => :unprocessable_entity }
      rescue Outgoing::ApplyForm::RuntimeError => cause
        logger.warn 'Apply form submission failed: #{cause.message}'
        format.xml  { render :xml => { :error => cause }.to_xml(:root => 'errors'), :status => :unprocessable_entity }
      end
    end
  end


end
