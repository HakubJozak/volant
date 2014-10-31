class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :messages

  # to allow Volant 1 and 2 run above the same DB at first
  self.table_name = 'devise_users'

  def name
    "#{first_name} #{last_name}"
  end

end
