class EmailContactSerializer < ApplicationSerializer
  attributes :id, :address, :name, :notes, :kind, :active, :organization_id
end

# == Schema Information
#
# Table name: email_contacts
#
#  id              :integer          not null, primary key
#  active          :boolean          default(FALSE)
#  address         :string(255)      not null
#  name            :string(255)
#  notes           :string(255)
#  organization_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  kind            :string(255)
#
