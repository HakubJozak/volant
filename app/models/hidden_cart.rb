class HiddenCart

  def initialize
    @hidden = Set.new
    @managed = Set.new
  end

  # default is hidden
  def register(key)
    unless @managed.include?(key)
      @managed.add(key)
      @hidden.add(key)
    end
  end

  def show(id)
    @hidden.delete(id)
  end

  def hide(id)
    @hidden.add(id)
  end

  def hidden?(id)
    @hidden.include?(id)
  end

  def visible?(id)
    not @hidden.include?(id)
  end
end
