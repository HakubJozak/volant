module ApplyForm::WebApi
  extend ActiveSupport::Concern

  def update_volunteer_data!
    [ :gender, :firstname, :lastname, :birthnumber, :nationality,
      :birthdate, :birthplace, :occupation, :email, :phone, :fax,
      :street, :city, :zipcode,
      :contact_street, :contact_city, :contact_zipcode,
      :emergency_day, :emergency_night, :emergency_name,
      :special_needs, :speak_well, :speak_some, :past_experience
    ].each do |attr|
      self.volunteer.send("#{attr}=", self.send(attr))
    end

    self.volunteer.save!
  end


  
  module ClassMethods
    def create_by_birthnumber(attrs)
      # TODO: replace by real DB attributes
      # delegate :firstname, :lastname, :gender, :email, :phone, :birthdate, :birthnumber,
      #          :nationality, :occupation, :account, :emergency_name, :emergency_day,
      #          :emergency_night, :speak_well, :speak_some, :special_needs, :past_experience, :comments,
      #          :fax, :street, :city, :zipcode, :contact_street, :contact_city, :contact_zipcode,
      #          :birthplace, :note, :male?, :female?, to: :volunteer, allow_nil: true

      form = nil
      volunteer = Volunteer.find_by_birthnumber(attrs[:birthnumber])

      workcamps = attrs.delete(:workcamp_ids).to_a.map do |id|
        ::Workcamp.find_by_id(id)
      end.compact

      ApplyForm.transaction do
        form = self.new(attrs)
        # form.volunteer.validate_phones!

        if form.save
          form.build_volunteer unless form.volunteer
          form.update_volunteer_data!
          form.save!

          workcamps.each_with_index do |wc,i|
            form.workcamp_assignments.create!(workcamp: wc, order: i+1)
          end
        end
      end

      form
    end

  end
end
