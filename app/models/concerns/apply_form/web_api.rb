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

    self.volunteer.save
  end


  
  module ClassMethods
    def create_by_birthnumber(attrs)
      form = nil

      workcamps = attrs.delete(:workcamp_ids).to_a.map do |id|
        ::Workcamp.find_by_id(id)
      end.compact

      ApplyForm.transaction do
        form = self.new(attrs)
        form.strict_validation_on!

        if form.save
          form.volunteer = Volunteer.find_by_birthnumber(form.birthnumber) || Volunteer.new
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
