class Vocative < ActiveRecord::Base

  validates :nominative, :vocative, :name_type, :gender,
            presence: true 

  class Name

    def initialize(nominative:, gender:, name_type: )
      @nominative = nominative
      type = name_type.to_s.match(/^first/) ? 'f' : 's'
      @scope = ::Vocative
                 .where(nominative: nominative.downcase)
                 .where(gender: gender)
                 .where(name_type: type)
    end

    def to_s
      @nominative
    end

    def vocative
      @scope.pluck(:vocative).first || @nominative
    end
  end

end
