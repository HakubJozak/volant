class PaymentSerializer < Barbecue::BaseSerializer
  has_one :apply_form, embed: :ids, include: true

  def self.public_attributes
    [ :id, :amount, :received, :description, :account, :mean, :returned_date, :returned_amount, :return_reason, :bank_code, :spec_symbol, :var_symbol, :const_symbol ]
  end

  attributes *PaymentSerializer.public_attributes

end
