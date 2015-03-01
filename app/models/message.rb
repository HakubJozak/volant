class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :apply_form
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments

  validates_presence_of :user
  validates_inclusion_of :action, in: %w(ask accept reject send infosheet ltv/ask ltv/accept ltv/reject ltv/send ltv/infosheet)

  scope :not_sent, lambda { where(sent_at: nil) }
#  validates_presence_of :from,:to,:subject,:body, if: :sending

  ALLOWED_ACTIONS = [ :accept, :reject, :ask, :infosheet ]

  def deliver!
    unless sent?
      ActiveRecord::Base.transaction do
        mail = MessageMailer.standard_email(self)
        mail.deliver
        self.sent_at = Time.now

        if apply_form && ALLOWED_ACTIONS.include?(action_to_perform)
          apply_form.send(action_to_perform)
          apply_form.save(validate: false)
        end

        save!
      end
    end
  end

  def sent?
    !self.sent_at.nil?
  end

  private

  def action_to_perform
    self.action =~ %r{([a-z]+)\z}
    $1.try(:to_sym)
  end


end
