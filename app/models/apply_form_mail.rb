class ApplyFormMail

  attr_accessor :subject, :to, :from, :body, :attachments
  attr_reader :form

  class DeliveryFailure < StandardError
  end

  def initialize(options)
    if options[:mail]
      init_from_hash(options)
    else
      @action = options[:action]
      @form = options[:form]
      @user = options[:user]
      @attachments = []
      init_fresh
    end

  end

  def deliver
    begin
      @to = ENV['all_mails_to'] if ENV.has_key?('all_mails_to')
      @from = ENV['all_mails_to'] if ENV.has_key?('all_mails_to')
      GenericMailer.deliver_plain_email(self)
    rescue => error
      RAILS_DEFAULT_LOGGER.error error.backtrace.join("\n")
      raise DeliveryFailure.new(error.message)
    end
  end

  protected

  def init_fresh
    @from = @user ? @user.email : ENV['volant_email_address']

    params = {}
    params[:wcname] = @form.current_workcamp ? @form.current_workcamp.name : ''
    params[:wccode] = @form.current_workcamp ? @form.current_workcamp.code : ''
    params[:volname] = @form.volunteer.name

    template = EmailTemplate.find_by_action(@action.to_s)
    template.bind_data('form', @form, ["workcamps_list"]) if @form
    template.bind_data('volunteer', @form.volunteer, ["name","age"]) if @form and @form.volunteer
    template.bind_data('wc', @form.current_workcamp, ["begin_string","end_string","name"]) if @form and @form.current_workcamp
    template.bind_data('user', @user, [ "name" ])

    @subject = template.get_subject
    @body = template.get_body

    # TODO - use polymorphism or the template itself?
    if @action == :ask
      # no layout and other sender
      @attachments << VefAttachment.new(@form)
      @to = @form.current_workcamp.organization.email
    elsif @action == :infosheet
      @form.current_workcamp.infosheets.each { |i| @attachments << i }
      @to = @form.volunteer.email
      @attachments.compact
    else
      @to = @form.volunteer.email
    end
  end

  def init_from_hash(hash)
    @from = hash[:mail][:from]
    @to = hash[:mail][:to]
    @subject = hash[:mail][:subject]
    @body = hash[:mail][:body]
    @attachments = hash[:mail][:attachments] || []

    @attachments.map! do |a|
      a[:type].constantize.create_from_params(a)
    end
    
    @attachments.compact!
  end

end
