class Vocative < ActiveRecord::Base
  def self.find_vocative(name_type, gender, nominative)
    result = Vocative.where(name_type: name_type, gender: gender, nominative: nominative.downcase ).first
    result ? result[:vocative] : nominative
  end
end
