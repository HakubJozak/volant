require 'test_helper'

class WorkcampIntentionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: workcamp_intentions
#
#  id             :integer          not null, primary key
#  code           :string(255)      not null
#  description_cz :string(255)      not null
#  created_at     :datetime
#  updated_at     :datetime
#  description_en :string(255)
#
