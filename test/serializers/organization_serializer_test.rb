require 'test_helper'


class OrganizationSerializerTest < ActiveSupport::TestCase

  def setup
    @org = Factory.create(:organization)
    @serializer = OrganizationSerializer.new(@org)
  end

  test "test emails" do
    @org.emails.create(address: 'out@example.com',kind: 'OUTGOING')
    @org.emails.create(address: 'in@example.com',kind: 'INCOMING')
    @org.emails.create(address: 'ltv@example.com',kind: 'LTV')        

    assert_equal 'out@example.com', @serializer.outgoing_email
    assert_equal 'in@example.com', @serializer.incoming_email
    assert_equal 'ltv@example.com', @serializer.ltv_email 
  end

end
