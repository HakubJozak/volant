require 'csv'

module Export
  module Excel

    module ApplyForm
      extend ActiveSupport::Concern

      module ClassMethods
        def to_csv
          apply_forms = joins(:volunteer).includes(:payment,current_workcamp: [ :intentions,:organization ]).
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
    end

  end
end
