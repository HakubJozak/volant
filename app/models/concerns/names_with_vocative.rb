module NamesWithVocative

  extend ActiveSupport::Concern

  def firstname
    ::Vocative::Name.new(
      nominative: read_attribute(:firstname),
      name_type: :first_name,
      gender: gender
    )
  end

  def lastname
    ::Vocative::Name.new(
      nominative: read_attribute(:lastname),
      name_type: :lastname,
      gender: gender
    )
  end  
end
