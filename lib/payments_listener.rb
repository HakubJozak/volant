class PaymentsListener < ProgressListener

  attr_accessor :payments

  def payment(p)
    @payments << p
  end

end
