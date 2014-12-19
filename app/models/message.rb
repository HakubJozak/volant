class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :apply_form

  validates_presence_of :user
  validates_inclusion_of :action, in: %w(ask accept reject send infosheet)

  scope :not_sent, lambda { where(sent_at: nil) }
#  validates_presence_of :from,:to,:subject,:body, if: :sending

  ALLOWED_ACTIONS = [ :accept, :reject, :ask, :infosheet ]

  def deliver!
    unless sent?
      ActiveRecord::Base.transaction do
        mail = MessageMailer.standard_email(self)
        mail.deliver
        self.sent_at = Time.now

        if apply_form && ALLOWED_ACTIONS.include?(action.to_sym)
          apply_form.send(action)
          apply_form.save!
        end

        save!
      end
    end
  end

  def sent?
    !self.sent_at.nil?
  end


end
