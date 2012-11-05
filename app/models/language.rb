# == Schema Information
#
# Table name: languages
#
#  id          :integer          not null, primary key
#  code        :string(2)
#  triple_code :string(3)        not null
#  name_cs     :string(255)
#  name_en     :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Language < ActiveRecord::Base
end
