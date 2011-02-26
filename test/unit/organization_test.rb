require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase


  def setup
    create_default_organization
    @seeds = Factory.create(:organization)
    @seeds.emails.create(:address => 'out@example.com', :kind => 'OUTGOING')
    @seeds.emails.create(:address => 'in@example.com', :kind => 'INCOMING')
    @seeds.emails.create(:address => 'fake@example.com', :kind => nil)
  end

  test "get default organization" do
    assert_not_nil Organization.default_organization
  end

  test "test outgoing email" do
    assert_equal 'out@example.com', @seeds.email
    assert_equal 'in@example.com', @seeds.email(:incoming)
  end

  test "there are two emails for Seed" do
    assert_equal 3, @seeds.emails.size
  end

  test "validation" do
    assert_validates_presence_of @seeds, :name, :code, :country
  end


end
