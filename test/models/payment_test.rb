require 'test_helper'

class PaymentTest < ActiveSupport::TestCase

  test "amount calculation" do
    p = Payment.new(:amount => 3000, :returned_amount => 100,
                    :received => Date.today, :returned_date => Date.today )
    p.save
    assert_equal 2900, p.amount
  end

  test "returned named scope" do
    assert_equal payments(:returned), Payment.returned.first
  end

  test "schema based validation works" do
    assert_valid payments(:normal)
    assert_validates_presence_of payments(:normal), :amount, :received, :mean
  end

  test "payment mean validation" do
    crippled = payments(:returned)
    crippled.mean = 'X'
    assert_invalid crippled, [ :mean ]

    crippled = payments(:from_bank)
    crippled.account = nil
    assert_validates_presence_of crippled, :account
  end

  test "returned properties conditionally validates" do
    assert_valid payments(:returned)

    # returned payment validation
    invalid_returned = payments(:returned)
    invalid_returned.returned_date = nil
    invalid_returned.return_reason = nil
    assert_invalid invalid_returned, [ :returned_date, :return_reason ]
  end

  test "conversion to CSV" do
    skip 'CSV export not implemented'
    assert_not_nil Payment.all.to_csv
  end
end
