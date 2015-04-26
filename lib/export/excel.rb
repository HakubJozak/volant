require 'csv'

module Export
  module Excel

    module ApplyForm
      extend ActiveSupport::Concern

      module ClassMethods
        def to_csv
          apply_forms = joins(:volunteer).includes(:payment,taggings: [:tag], current_workcamp: [ :intentions,:organization ]).
            references(:current_workcamp,:current_assignment,:payment)

          form_attrs = [ :id,:created_at, :cancelled,
                         :firstname, :lastname, :gender, :age, :birthnumber, :birthdate,
                         :nationality, :occupation, :email, :phone,
                         :street, :city, :zipcode, :contact_street, :contact_city, :contact_zipcode,
                         :emergency_name, :emergency_day, :emergency_night,
                         :special_needs, :past_experience, :tags,
                         :general_remarks, :motivation, :fee ]
          payment_attrs = [ :amount, :received, :description, :returned_date, :returned_amount, :return_reason ]
          org_attrs = [ :country_name, :country_region, :country_zone, :name, :code, :networks, :phone, :mobile ]
          wc_attrs = [ :code, :name, :begin, :end, :intentions, :extra_fee ]

          ::CSV.generate(:col_sep => ';') do |csv|
            h = []
            h.concat csv_header( form_attrs, 'Application')
            h.concat csv_header( payment_attrs, 'Payment')
            h.concat csv_header( wc_attrs, 'Workcamp')
            h.concat csv_header( org_attrs, 'Organization')
            csv << h

            apply_forms.find_each do |form|
              d = []
              wc = form.current_workcamp
              d.concat csv_data(form_attrs, form)
              d.concat csv_data(payment_attrs, form.payment)
              d.concat csv_data(wc_attrs, wc)
              d.concat csv_data(org_attrs, wc ? wc.organization : nil)
              csv << d
            end
          end
        end

        protected

        def csv_header(attrs, model)
          attrs.map { |a| "#{model} - #{a.to_s}" }
        end

        def csv_data(attrs, obj)
          # use empty array if the object is nil
          return attrs.map { nil } unless obj

          attrs.map do |a|
            value = obj.send(a)

            if Date === value or a == :created_at
              I18n.l(value.to_date) rescue nil
            elsif [:intentions,:networks,:tags].include?(a)
              value.join(',') rescue nil
            else
              value
            end
          end
        end
      end
    end

    module Workcamp
      extend ActiveSupport::Concern

  # CSV_FIELDS = %w(name code country organization)
  # acts_as_convertible_to_csv :fields => CSV_FIELDS, :format_options => {
  #                                                 :country => :format_for_csv,
  #                                                 :organization => :format_for_csv
  #                                                  :networks => :format_for_csv
  #                                                 }



      module ClassMethods

        CSV_COLUMNS = [:id, :code, :name, :country_code,
                       :country_name, :org_code, :org_name,
                       :org_networks, :language, :from,:to, :capacity,
                       :places, :places_for_males,
                       :places_for_females,
                       :free_places_for_males,
                       :free_places_for_females, :project_id,
                       :duration, :free_capacity_males,
                       :free_capacity_females, :free_capacity,
                       :apply_forms_total, :apply_forms_accepted,
                       :apply_forms_cancelled,
                       :minimal_age,
                       :maximal_age, :area, :accomodation, :workdesc,
                       :notes, :description, :created_at, :updated_at,
                       :extra_fee, :extra_fee_currency, :region,
                       :capacity_natives, :capacity_teenagers,
                       :capacity_males, :capacity_females, :airport,
                       :train, :publish_mode, :accepted_places,
                       :accepted_places_males,
                       :accepted_places_females, :asked_for_places,
                       :asked_for_places_males,
                       :asked_for_places_females, :type, :longitude,
                       :latitude, :state, :requirements, :free_places ]

        def to_csv
          ::CSV.generate(:col_sep => ';') do |csv|
            csv << CSV_COLUMNS.map { |attr| csv_header(attr) }
            
            find_each do |wc|
              csv << CSV_COLUMNS.map { |attr| csv_value(wc,attr) }
            end
          end
        end

        protected

        def csv_header(attr)
          case attr
          when :apply_forms_total
            'Applications - Total'
          when :apply_forms_accepted
            'Applications - Accepted'
          when :apply_forms_cancelled
            'Applications - Cancelled'
          when :project_id
            'Project ID'
          else
            attr.to_s.humanize.capitalize            
          end
        end

        def csv_value(wc,attr)
          case attr
          when :from, :to
            if val = wc.send(attr)
              I18n.l(val.to_date)
            else
              ''
            end
          when :country_name then wc.country.name
          when :country_code then wc.country.code
          when :org_name then wc.organization.name
          when :org_code then wc.organization.code
          when :apply_forms_total
            wc.apply_forms.count
          when :apply_forms_accepted
            wc.apply_forms.accepted.count                  
          when :apply_forms_cancelled
            wc.apply_forms.cancelled.count                  
          when :org_networks
            wc.organization.networks.map(&:name).join(',')
          else
            value = wc.send(attr)
          end
        end
        
      end

    end

  end
end
