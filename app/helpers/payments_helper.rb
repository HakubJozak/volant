module PaymentsHelper

   ApplicationHelper::date_fields :received, :returned_date

   def apply_form_form_column(record, input_name)
     belongs_to_auto_completer_as :apply_form, :name
   end

  def amount_column(record)
    volant_number_to_currency(record.amount)
  end

  def mean_column(record)
    Payment.human_attribute_name("#{record.mean.downcase}")
  end

  def mean_form_column(record, input_name)
    options = [[ Payment.human_attribute_name("bank"), 'BANK'],
               [ Payment.human_attribute_name("cash") , 'CASH']]
    select(:record, :mean, options)
  end

  def mean_form_column(record, input_name)
    options = [[ Payment.human_attribute_name("bank"), 'BANK'],
               [ Payment.human_attribute_name("cash") , 'CASH']]
    select(:record, :mean, options)
  end

end
