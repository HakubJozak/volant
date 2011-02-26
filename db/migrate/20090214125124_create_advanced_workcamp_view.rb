class CreateAdvancedWorkcampView < ViewMigration

  def self.up
    stmt =  "select w.*,"
    stmt << "  w.places - coalesce(whole.booked,0) as free_places,"
    stmt << "  w.places_for_males - coalesce(males.booked,0) as free_places_for_males,"
    stmt << "  w.places_for_females - coalesce(females.booked,0) as free_places_for_females "
    stmt << "from workcamps w "
    stmt << " left outer join (#{count_booked_statement(:all)}) AS whole ON w.id = whole.id "
    stmt << " left outer join (#{count_booked_statement(:males)}) AS males ON w.id = males.id "
    stmt << " left outer join (#{count_booked_statement(:females)}) AS females ON w.id = females.id "

    create_view('workcamps_view', 'workcamps', Workcamp, stmt,"workcamps.*,2::bigint,2::bigint,2::bigint")
  end

  def self.down
    drop_view('workcamps_view')
  end

  protected

  # Creates statement that counts 'some' workcamp assignments for all workcamps.
  # 'category'
  def self.count_booked_statement(category)
    where = ' WHERE accepted IS NOT NULL '

    case category
      when :all
        result_alias = 'booked'

      when :males
        where << " AND v.gender = 'm'"
        result_alias = 'booked_males'

      when :females
        where << " AND v.gender = 'f'"
        result_alias = 'booked_females'
    end

    stmt = " select current_workcamp_id as id, count(f.id) as booked "
    stmt << " from apply_forms_view f "
    stmt << " inner join volunteers v on v.id = f.volunteer_id "
    stmt << where
    stmt << " group by f.current_workcamp_id"
  end
end
