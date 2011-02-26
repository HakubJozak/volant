class CancelledState < ApplyFormState

  def initialize(time)
    super(:cancelled, time)
  end

  def info

  end
end
