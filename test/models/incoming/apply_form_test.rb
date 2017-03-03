require 'test_helper'

module Incoming
  class ApplyFormTest < ActiveSupport::TestCase
    context "Incoming::ApplyForm" do
    end
  end
end

# == Schema Information
#
# Table name: apply_forms
#
#  id                           :integer          not null, primary key
#  volunteer_id                 :integer
#  fee                          :decimal(10, 2)   default(2200.0), not null
#  cancelled                    :datetime
#  general_remarks              :text
#  motivation                   :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  current_workcamp_id_cached   :integer
#  current_assignment_id_cached :integer
#  type                         :string(255)      default("Outgoing::ApplyForm"), not null
#  confirmed                    :datetime
#  organization_id              :integer
#  country_id                   :integer
#  firstname                    :string(255)
#  lastname                     :string(255)
#  gender                       :string(255)
#  email                        :string(255)
#  phone                        :string(255)
#  birthnumber                  :string(255)
#  occupation                   :string(255)
#  account                      :string(255)
#  emergency_name               :string(255)
#  emergency_day                :string(255)
#  emergency_night              :string(255)
#  speak_well                   :string(255)
#  speak_some                   :string(255)
#  fax                          :string(255)
#  street                       :string(255)
#  city                         :string(255)
#  zipcode                      :string(255)
#  contact_street               :string(255)
#  contact_city                 :string(255)
#  contact_zipcode              :string(255)
#  birthplace                   :string(255)
#  nationality                  :string(255)
#  special_needs                :text
#  past_experience              :text
#  comments                     :text
#  note                         :text
#  birthdate                    :date
#  passport_number              :string(255)
#  passport_issued_at           :date
#  passport_expires_at          :date
#
