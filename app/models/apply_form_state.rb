class ApplyFormState

  attr_reader :time
  attr_reader :name
  attr_reader :actions

  def self.create(form)
    return CancelledState.new(form) if form.cancelled

    [ :infosheeted, :accepted, :rejected, :asked ].each do |field|
      time = form.send(field)
      return ApplyFormState.new(field, time, form) if time
    end

    if form.paid?
      ApplyFormState.new(:paid, form.payment.try(:received), form)
    else
      ApplyFormState.new(:not_paid, Date.today, form)
    end
  end

  def initialize(name, time, form)
    @name = name
    @form = form

    @actions = case name
               when :asked
                 [ :accept, :reject,  :cancel ]
               when :paid
                 [ :ask, :reject,  :cancel ]
               when :accepted
                 [ :infosheet,  :cancel ]
               when :rejected
                 [  :cancel ]
               when :not_paid
                 [ :pay,  :cancel ]
               when :infosheeted
                 [  :cancel ]
               else []
               end

    # remove workcamp related actions, if there is no current workcamp
    unless form.current_assignment
      @actions.delete_if { |k,v| [ :ask,:accept,:reject,:infosheet ].include?(k) }
    end

    # TODO - solve in model
    @time = if String === time
              Time.parse time
            else
              time
            end
  end


  def info
    info_box("apply_form_states.info")
  end

  def to_label
    info_box("apply_form_states")
  end

  def ==(other)
    case other
      when Symbol
        self.name == other
      when ApplyFormState
        self.name == other.name
      else
        false
    end
  end

  protected

  def info_box(key)
    time_in_string = I18n.localize(@time.to_date) if @time
    I18n.t("activerecord.attributes.apply_form.#{key}.#{name}", :time => time_in_string)
  end
end
