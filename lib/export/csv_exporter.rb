module Export::CsvExporter
  def initialize(scope)
    @scope = scope
  end

  def to_csv
    ::CSV.generate(:col_sep => ';') do |csv|
      csv << columns.map { |c| csv_header(c) }

      @scope.find_each do |wc|
        csv << columns.map { |c| csv_value(wc,c) }
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
