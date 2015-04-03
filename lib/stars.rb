module Stars
  module User
    extend ActiveSupport::Concern

    included do
      has_many :starrings
      has_many :favorites, through: :starrings, validate: false
    end

    def has_starred?(object)
      @favs ||= starrings.all
      @favs.any? { |s| s.favorite == object }
    end
  end

  module Model
    extend ActiveSupport::Concern

    included do
      has_many :starrings, as: :favorite

      scope :starred_by, lambda { |user|
        joins(:starrings).where("starrings.user_id = ?",user.id)
      }
    end
    
    def starred?(user)
      # user.starrings.all.find { |s| s.favorite == self }
      # user.starrings.where(favorite: self).exists?
      user.favorite?(self)
    end

    def remove_star(user)
      starrings.where(user: user).delete_all
    end

    def add_star(user)
      starrings.where(user: user).create
    end
  end
end
