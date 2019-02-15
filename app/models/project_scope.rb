class ProjectScope

  MODES = %w( incoming outgoing ltv ).freeze
  YEARS = (2009 .. (Date.today.year + 1)).to_a.reverse.freeze

  def initialize(session)
    @session = session
  end

  def incoming?
    mode == :incoming
  end

  def outgoing?
    mode == :outgoing?
  end

  def mode=(val)
    @session[:project_mode] = val
  end

  def year=(val)
    @session[:project_year] = val
  end

  def mode
    (@session[:project_mode] || :outgoing).to_sym
  end

  def year
    @session[:project_year] || Date.today.year
  end

end
