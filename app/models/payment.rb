# -*- coding: utf-8 -*-
class Payment < ActiveRecord::Base
  create_date_time_accessors #"returned_date"


  CSV_FIELDS = %w(amount received returned_amount returned_date return_reason)

  belongs_to :apply_form, :class_name => 'Outgoing::ApplyForm'

  validates_presence_of :returned_date, :if => Proc.new { |p| p.return_reason or p.returned_amount }
  validates_presence_of :return_reason, :if => Proc.new { |p| p.returned_date or p.returned_amount }
  validates_presence_of :returned_amount, :if => Proc.new { |p| p.returned_date or p.return_reason }
  validates_presence_of :amount, :received, :mean

  validates_presence_of :account, :if => proc { |p| p.bank? }
  validates_inclusion_of :mean, :in => %w( CASH BANK )

  scope :returned, :conditions => [ 'returned_amount IS NOT NULL']
  scope :not_assigned, :conditions => [ 'apply_form_id IS NULL']

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

end
