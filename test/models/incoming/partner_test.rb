require 'test_helper'

class Incoming::PartnerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: partners
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  contact_person     :string(255)
#  phone              :string(255)
#  email              :string(255)
#  address            :string(2048)
#  website            :string(2048)
#  negotiations_notes :string(5096)
#  notes              :text
#  created_at         :datetime
#  updated_at         :datetime
#
