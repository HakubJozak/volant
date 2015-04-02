module Stars
  module Model
    extend ActiveSupport::Concern

    included do
      has_many :starrings, as: :favorite

      scope :starred_by, lambda { |user|
        joins(:starrings).where("starrings.user_id = ?",user.id)
      }
    end

    def starred?(user)
      user.starrings.all.find { |s| s.favorite == self }
    end

    def remove_star(user)
      starrings.where(user: user).delete_all
    end

    def add_star(user)
      starrings.where(user: user).create
    end
  end
end
