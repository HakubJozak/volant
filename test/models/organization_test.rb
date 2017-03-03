require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase


  def setup
    @seeds = Factory.create(:organization)
    @seeds.emails.create(:address => 'out@example.com', :kind => 'OUTGOING')
    @seeds.emails.create(:address => 'in@example.com', :kind => 'INCOMING')
    @seeds.emails.create(:address => 'fake@example.com', :kind => nil)
  end

  test "get default organization" do
    assert_not_nil Organization.default_organization
  end

  test "there are three emails for Seeds" do
    assert_equal 3, @seeds.emails.size
  end

  test "validation" do
    assert_validates_presence_of @seeds, :name, :code, :country
  end


end

# == Schema Information
#
# Table name: organizations
#
#  id             :integer          not null, primary key
#  country_id     :integer          not null
#  name           :string(255)      not null
#  code           :string(255)      not null
#  address        :string(255)
#  contact_person :string(255)
#  phone          :string(255)
#  mobile         :string(255)
#  fax            :string(255)
#  website        :string(2048)
#  created_at     :datetime
#  updated_at     :datetime
#
