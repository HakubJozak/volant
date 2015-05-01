require 'csv'

module Export
  module FridayList
    module Workcamp
      extend ActiveSupport::Concern

      module ClassMethods
        def friday_list
          columns = [ :code, :name, :from, :to, :minimal_age,
                      :maximal_age, :intentions, :capacity, :free_capacity,
                      :free_capacity_females, :free_capacity_males ]

          ::CSV.generate(:col_sep => ';') do |csv|
            csv << columns.map { |c| csv_header(c) }

            find_each do |wc|
              csv << columns.map { |c| csv_value(wc,c) }
            end
          end

        end

        private

        def csv_value(wc,attr)
          case attr
          when :from, :to
            if val = wc.send(attr)
              I18n.l(val.to_date)
            end
          when :intentions
            wc.intentions.map(&:code).join(',')
          when :tags
            wc.tag_list
          else
            value = wc.send(attr)
          end
        end

        def csv_header(attr)
          attr.to_s.humanize.capitalize
        end
      end
    end
  end
end
