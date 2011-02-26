module WorkcampSearch

  def self.total(query)
    query ||= {}
    Workcamp.count(create_conditions(query))
  end

  # TODO - rewrite by hash conditions
  def self.find_by_query(query = {}, page = 1, per_page = 15)
    query ||= {}
    offset = (page.to_i - 1) * per_page.to_i
    offset = 0 if offset < 0

    find_options = create_conditions(query).merge :limit => per_page, :offset => offset
    workcamps = Workcamp.find(:all, find_options)
  end

  protected

  def self.create_conditions(query = {})
    sql = '"begin" < ? '
    # params = [ Parameter.get_value(SEASON_START_PARAM) ]
    # TODO - season start!!!
    params = [ 20.years.from_now ]

    if is_set query, :countries
      # FIXME - security issue!!!
      codes = query[:countries].map { |code| "'#{code}'" }.join(',')
      sql << " AND countries.code in (#{codes}) "
    end

    if query[:from]
      sql += " AND (#{Workcamp.table_name}.\"begin\" >= ?) "
        params << query[:from]
    end

    if query[:to]
        sql += " AND (#{Workcamp.table_name}.\"end\" <= ?) "
        params << query[:to]
    end

    if is_set( query, :intentions)
        sql += ' AND (intentions.id in (?)) '
        params << query[:intentions]
    end

    if is_set( query, :sex)
      sql += " AND #{free_places('_for_males')} > 0 " if query[:sex] == MALE
      sql += " AND #{free_places('_for_females')} > 0 " if query[:sex] == FEMALE
    end

    if query[:free_only]
      sql += " AND #{free_places} > 0 "
    end

    age = query[:age].to_i
    if query[:age] == age
        sql += " AND (#{Workcamp.table_name}.minimal_age <= ? and #{Workcamp.table_name}.maximal_age >= ?) "
        params << age << age
    end


    { :conditions => [ sql ].concat(params),
      :joins => [
                 "LEFT JOIN workcamp_intentions_workcamps ON #{Workcamp.table_name}.id = workcamp_intentions_workcamps.workcamp_id",
                 "LEFT JOIN workcamp_intentions as intentions ON workcamp_intentions_workcamps.workcamp_intention_id = intentions.id",
                 "INNER JOIN countries ON #{Workcamp.table_name}.country_id = countries.id"
                ] }
  end

  private

  def self.free_places(sufix = '')
    "(places#{sufix} - asked_for_places#{sufix} - accepted_places#{sufix})"
  end

  def self.is_set( query, field)
    query[field] and (not query[field].empty?)
  end

end
