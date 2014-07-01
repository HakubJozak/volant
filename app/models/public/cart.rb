class Public::Cart < Public::CountryCart

  def initialize
    super
    @workcamps = []
    @just_changed = nil
  end

  def sort(new_order)
    new_order.map! { |id| id.to_i }
    @workcamps.sort! do |w1,w2|
      new_order.index(w1) <=> new_order.index(w2)
    end
  end

  def just_changed
    #Workcamp.find( :all, :conditions => [ 'id in (?)', @just_changed] )
    Workcamp.find(@just_changed)
  end

  # TODO - get limit from parameter and check it
  # TODO - inform about problem states
  def add_workcamp(wc_to_add)
    new_id = (Integer === wc_to_add)? wc_to_add : wc_to_add.id
    existing = @workcamps.find { |id| id == new_id }

    unless existing
      @workcamps << new_id
      @just_changed = [ new_id ]
    else
      @just_changed = nil
    end

    self
  end

  def remove_workcamp( wc_to_remove)
     @workcamps.delete wc_to_remove.id
     @just_changed = [ wc_to_remove.id ]
     self
  end

  # TODO - reimplement?
  def contains?(workcamp)
    @workcamps.find{ |other_id| workcamp.id == other_id } != nil
  end

  def empty!
    @just_changed = @workcamps
    @workcamps = []
  end

  def empty?
    @workcamps.empty?
  end

  def size
    @workcamps.size
  end

  # Find all Workcamp AR objects and returns their array.
  def workcamps
    begin
      Workcamp.find(@workcamps).sort do |a,b|
        @workcamps.index(a.id) <=> @workcamps.index(b.id)
      end
    rescue => e
      Rails.logger.error "Failed to find workcamps in cart: #{e}"
      @workcamps = []
    end
  end

  def workcamps_ids
    @workcamps.dup.compact
  end

end
