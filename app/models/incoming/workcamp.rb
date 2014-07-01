class Incoming::Workcamp < ::Workcamp
  default_scope -> { order 'begin' }

  has_many :leaderships, :class_name => 'Incoming::Leadership'
  has_many :leaders, :through => :leaderships, :class_name => 'Incoming::Leader'

  has_many :hostings, :class_name => 'Incoming::Hosting'
  has_many :partners, :through => :hostings, :class_name => 'Incoming::Partner'

  has_many :bookings, :class_name => 'Incoming::Booking'
  has_many :participants, :class_name => 'Incoming::Participant', :dependent => :nullify

  def free_places
    capacity - participants.not_cancelled.count - bookings.count
  end

  def free_places_for_males
    [ free_places, capacity_males - bookings.males.count - participants.males.not_cancelled.count ].min
  end

  def free_places_for_females
    [ free_places, capacity_females - bookings.females.count - participants.females.not_cancelled.count ].min
  end

  # TODO - specify dates
  def self.free
    all.select { |wc| wc.free_places > 0 }
  end

  # return comma separated string listing nationalities which
  # are not allowed for this workcamp any more
  def no_more_nationalities
    nations = participants.not_cancelled.map { |p| p.nationality.to_s.downcase.strip }
    nations.uniq.select { |x| nations.count(x) > 1}.map { |n| n.capitalize }
  end

  protected

  # avoid nils
  [ '', '_males', '_females' ].each do |sufix|
    attr = "capacity#{sufix}"
    define_method(attr) do
      read_attribute(attr) || read_attribute('capacity') || 0
    end
  end

  public

  def self.friday_list
    # TODO - set friday list locale and time span
    locale = 'en'
    attrs = [ :code, :name, :intentions, :begin, :end, :capacity,
              :minimal_age, :maximal_age,
              :free_places, :free_places_for_males, :free_places_for_females,
              :no_more_nationalities,
              :comments ]

    FasterCSV.generate(:col_sep => ';') do |csv|
      csv << attrs.map { |attr| Incoming::Workcamp.human_attribute_name(attr, :locale => locale) }

      free.each do |wc|
        csv << attrs.map do |attr|
          case attr
          #when :begin, :end then I18n.localize(wc.send(attr), :locale => locale, :format => :long)
          when :begin, :end then wc.send(attr).nil? ? '-' : wc.send(attr).strftime('%d/%m/%Y')
          when :intentions then wc.intentions.join('/')
          when :no_more_nationalities then wc.no_more_nationalities.join(',')
          when :free_places, :free_places_for_females, :free_places_for_males then [0,wc.send(attr)].max
          when :comments then ''
          else wc.send(attr)
          end
        end
      end
    end
  end

  def participants_to_csv
    FasterCSV.generate(:col_sep => ';') do |csv|
      attrs = [ :cancelled, :nationality, :name, :gender, :age, :birthdate, :email, :phone, :general_remarks,
                :note, :tags, :emergency_name, :emergency_day, :emergency_night ]
      attrs.map! { |a| Incoming::Participant.human_attribute_name(a) }
      csv << [ Organization.human_name, Country.human_name, attrs ].flatten

      self.participants.each do |p|
        # participant has birthday during workcamp?
        before = p.age(self.begin.to_date)
        after = p.age(self.end.to_date)
        age = (before == after) ? before : "#{before}/#{after}"
        birthday = p.birthdate ? I18n.localize(p.birthdate) : '-'

        csv << [ p.organization.name,
                 p.country.name,
                 p.cancelled? ? I18n.t('yes') : I18n.t('no'),
                 p.nationality,
                 p.lastname.upcase + ' ' + p.firstname,
                 Person::gender_attribute_name(p.gender),
                 age,
                 birthday,
                 p.email,
                 p.phone,
                 p.general_remarks,
                 p.note,
                 p.tags.join(','),
                 p.emergency_name,
                 p.emergency_day,
                 p.emergency_night,
               ]

      end
    end
  end

  protected

  def make_csv_header(attrs)
    attrs.each do |a|
      if Array === a
        a[0]
      end
    end
  end

  def make_csv_row(attrs, row)

  end

end
