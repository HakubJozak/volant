class PaymentSerializer < ApplicationSerializer
  has_one :apply_form, embed: :ids, include: true

  writable_attributes :amount, :received, :description, :account, :mean, :returned_date, :returned_amount, :return_reason, :bank_code, :spec_symbol, :var_symbol, :const_symbol
  readonly_attributes :id

end

# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  apply_form_id   :integer
#  old_schema_key  :integer
#  amount          :decimal(10, 2)   not null
#  received        :date             not null
#  description     :string(1024)
#  account         :string(255)
#  mean            :string(255)      not null
#  returned_date   :date
#  returned_amount :decimal(10, 2)
#  return_reason   :string(1024)
#  bank_code       :string(4)
#  spec_symbol     :string(255)
#  var_symbol      :string(255)
#  const_symbol    :string(255)
#  name            :string(255)
#
