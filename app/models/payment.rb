# -*- coding: utf-8 -*-
class Payment < ActiveRecord::Base
  validates_lengths_from_database
  
  create_date_time_accessors #"returned_date"

  CSV_FIELDS = %w(amount received returned_amount returned_date return_reason)

  belongs_to :apply_form, :class_name => 'Outgoing::ApplyForm'

  validates_presence_of :returned_date, :if => :returned?
  validates_presence_of :return_reason, :if => :returned?
  validates_presence_of :returned_amount, :if => :returned?
  validates_presence_of :amount, :received, :mean

  validates_presence_of :account, :if => proc { |p| p.bank? }
  validates_inclusion_of :mean, :in => %w( CASH BANK )

  scope :year, lambda { |year|
    year = year.to_i
    where '(received >= ? AND received < ?)', Date.new(year,1,1), Date.new(year + 1,1,1)    }

  scope :returned, -> { where 'returned_amount IS NOT NULL' }
  scope :not_assigned, -> { where 'apply_form_id IS NULL' }

  scope :query, lambda { |query|
    fuzzy_like(query,'payments.return_reason','payments.account','payments.name')
  }

  def to_label
    # TODO
    "platba číslo #{id}"
  end

  def bank?
    mean == 'BANK'
  end

  def cash?
    mean == 'CASH'
  end

  def amount
    cash = read_attribute(:amount)
    return nil unless cash

    returned = self.returned_amount || 0
    cash - returned
  end

   def returned?
     returned_amount.present? or
     returned_date.present? or
     return_reason.present?
   end



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
