class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, # :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :account
  has_many :messages, validate: false

  include Stars::User

  

  # to allow Volant 1 and 2 run above the same DB at first
  self.table_name = 'devise_users'

  def name
    "#{first_name} #{last_name}"
  end

end
