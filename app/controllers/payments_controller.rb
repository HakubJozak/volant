class PaymentsController < ApplicationController
  active_scaffold :payments do |config|
    config.columns = [ :apply_form,
                       :amount,
                       :received,
                       :mean,
                       :account,
                       :bank_code,
                       :description ]


    #config.create.label = I18n.t('create_payment')
    group config, Payment.human_attribute_name('payment_return_group'),
                  :returned_amount, :returned_date_string, :return_reason, :collapsed => true


    # config.action_links.add :import,
    #                         :label => I18n.t('import_payments'),
    #                         :type => :table,
    #                         :method => :get,
    #                         :inline => false

    highlight_required(config, Payment)
  end

  def do_new
    @record = Payment.new(:mean => 'BANK',
                          :received => Date.today,
                          :amount => 2200 )
  end

  def import
  end

end
