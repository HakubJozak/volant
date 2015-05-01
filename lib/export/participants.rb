require 'csv'

class Export::Participants
  include CsvExporter

  def columns
    [:organization, :country, :nationality, :passport_number, :lastname, :firstname, :gender, :age, :birthdate, :email, :phone, :emergency_name, :emergency_day, :emergency_night, :special_needs, :note, :general_remarks, :tags ]
  end

  def each_record(&block)
    @scope.order(:country_id).each(&block)
  end

  private

  def csv_value(form,attr)
    case attr
    when :gender
      if form.send(attr) == 'f'
        'female'
      else
        'male'
      end
    when :birthdate
      format_date form.send(attr)
    when :organization
      form.organization.name
    when :country
      form.country.name      
    when :tags
      form.tag_list
    else
      value = form.send(attr)
    end
  end

end
