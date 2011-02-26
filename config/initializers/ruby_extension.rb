class Array

  # extends
  attr_accessor :total

  # Rejects empty and nil elements from the array.
  def without_blanks
    reject { |o| o.nil? or o.strip.empty? }
  end

  # Rejects! empty and nil elements from the array.
  def without_blanks!
    reject! { |o| o.nil? or o.strip.empty? }
    self
  end

end
