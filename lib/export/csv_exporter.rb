module Export::CsvExporter
  def initialize(scope)
    @scope = scope
  end

  def each_record(&block)
    @scope.find_each(&block)
  end


  def to_csv
    ::CSV.generate(:col_sep => ';') do |csv|
      csv << columns.map { |c| csv_header(c) }

      each_record do |record|
        csv << columns.map { |c| csv_value(record,c) }
      end
    end
  end

  private

  def csv_header(attr)
    attr.to_s.humanize.capitalize
  end

  def format_date(val)
    if val
      I18n.l(val.to_date)
    end    
  end

  def format_list(list,attr)
    list.map { |r| r.send(attr) }.join(',')
  end
end
