class Message < ActiveRecord::Base

  belongs_to :user
#  belongs_to :workcamp_assignment
  belongs_to :email_template
  has_one :apply_form

  validates_presence_of :user
  validates_inclusion_of :action, in: %w(ask accept reject send infosheet)

  def deliver!
    unless sent?
      ActiveRecord::Base.transaction do
        mail = MessageMailer.standard_email(self)
        mail.deliver
        self.sent_at = Time.now
        save!
      end
    end
  end

  def sent?
    !self.sent_at.nil?
  end


end
