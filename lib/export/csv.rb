module Export
  module Csv
    
    def self.outgoing_apply_forms(options = {})
      year = options[:year] || Date.today.year
      apply_forms = Outgoing::ApplyForm.year(year)

      form_attrs = [ :created_at, :cancelled, :general_remarks, :motivation, :fee ]
      payment_attrs = [ :amount, :received, :description, :returned_date, :returned_amount ]
      org_attrs = [ :country, :name, :networks, :phone, :mobile ]
      wc_attrs = [ :code, :name, :begin, :end, :intentions, :extra_fee ]
      volunteer_attrs = [ :firstname, :lastname, :gender, :age, :birthnumber, :birthdate, 
                          :nationality, :occupation, :email, :phone,
                          :street, :city, :zipcode, :contact_street, :contact_city, :contact_zipcode,
                          :emergency_name, :emergency_day, :emergency_night,
                          :special_needs, :past_experience, :tags ]


      FasterCSV.generate(:col_sep => ';') do |csv|
        h = []
        h.concat header( form_attrs, Outgoing::ApplyForm)
        h.concat header( payment_attrs, Payment)
        h.concat header( volunteer_attrs, Volunteer)
        h.concat header( wc_attrs, Outgoing::Workcamp)
        h.concat header( org_attrs, Organization)
        csv << h

        apply_forms.each do |form|
          d = []
          wc = form.current_workcamp
          d.concat data( form_attrs, form)
          d.concat data( payment_attrs, form.payment)
          d.concat data( volunteer_attrs, form.volunteer)
          d.concat data( wc_attrs, wc)
          d.concat data( org_attrs, wc ? wc.organization : nil)
          csv << d
        end
      end      
    end

    protected

    def self.header(attrs, clazz)
      cname = clazz.human_name
      attrs.map { |a| "#{cname} - #{clazz.human_attribute_name(a)}" }
    end

    def self.data(attrs, obj)
      # use empty array if the object is nil
      obj = attrs.map { nil } unless obj
   
      attrs.map do |a| 
        value = obj.send(a) rescue nil

        if Date === value or a == :created_at
          I18n.l(value.to_date) rescue nil
        elsif a == :intentions or a == :networks
          value.join(',') rescue nil
        else 
          value
        end
      end
    end


    def self.filter_ids(attrs)
      attrs.reject do |attr|
	attr.to_s =~ /.*id/
      end
    end

  end
end
