require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
end

# == Schema Information
#
# Table name: languages
#
#  id          :integer          not null, primary key
#  code        :string(2)
#  triple_code :string(3)        not null
#  name_cz     :string(255)
#  name_en     :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#
