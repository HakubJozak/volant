class Message < ActiveRecord::Base

  belongs_to :user
  validates_presence_of :user

  def send!
    ActiveRecord::Base.transaction do
      MessageMailer.standard_email(self).deliver
      sent_at = Time.now
      save!
    end
  end

  def sent?
    !!sent_at
  end
end
