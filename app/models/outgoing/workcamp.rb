module Outgoing
  class Workcamp < ::Workcamp
    create_date_time_accessors
    validates :from, :to, presence: true

    def open_for_application
      from.nil? || from >= Time.now.to_date
    end

    def adih_project_type
      'STV' # Short term (workcamp)      '
    end

    def price
      read_attribute(:price) ||
        if (country.region.to_i == 2)
          2500
        else
          2200
        end
    end
  end
end

# == Schema Information
#
# Table name: workcamps
#
#  id                       :integer          not null, primary key
#  code                     :string(255)      not null
#  name                     :string(255)      not null
#  country_id               :integer          not null
#  organization_id          :integer          not null
#  language                 :string(255)
#  begin                    :date
#  end                      :date
#  capacity                 :integer
#  places                   :integer          not null
#  places_for_males         :integer          not null
#  places_for_females       :integer          not null
#  minimal_age              :integer          default(18)
#  maximal_age              :integer          default(99)
#  area                     :text
#  accommodation            :text
#  workdesc                 :text
#  notes                    :text
#  description              :text
#  created_at               :datetime
#  updated_at               :datetime
#  extra_fee                :decimal(10, 2)
#  extra_fee_currency       :string(255)
#  region                   :string(65536)
#  capacity_natives         :integer
#  capacity_teenagers       :integer
#  capacity_males           :integer
#  capacity_females         :integer
#  airport                  :string(255)
#  train                    :string(4096)
#  publish_mode             :string(255)      default("ALWAYS"), not null
#  accepted_places          :integer          default(0), not null
#  accepted_places_males    :integer          default(0), not null
#  accepted_places_females  :integer          default(0), not null
#  asked_for_places         :integer          default(0), not null
#  asked_for_places_males   :integer          default(0), not null
#  asked_for_places_females :integer          default(0), not null
#  type                     :string(255)      default("Outgoing::Workcamp"), not null
#  longitude                :decimal(11, 7)
#  latitude                 :decimal(11, 7)
#  state                    :string(255)
#  requirements             :text
#  free_places              :integer          default(0), not null
#  free_places_for_males    :integer          default(0), not null
#  free_places_for_females  :integer          default(0), not null
#  project_id               :string(255)
#  duration                 :integer
#  free_capacity_males      :integer          default(0), not null
#  free_capacity_females    :integer          default(0), not null
#  free_capacity            :integer          default(0), not null
#  partner_organization     :string(4096)
#  project_summary          :string(4096)
#
