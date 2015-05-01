require 'csv'

class Export::FridayList
  include CsvExporter
  
  def columns
    [ :code, :name, :from, :to, :minimal_age,
      :maximal_age, :intentions, :tags, :capacity, :free_capacity,
      :free_capacity_females, :free_capacity_males, :no_more ]    
  end

  def to_csv
    # HACK
    raise 'Too big friday list' if @scope.count > 500

    ::CSV.generate(:col_sep => ';') do |csv|
      csv << columns.map { |c| csv_header(c) }
      @scope.includes(apply_forms: :country).all.each do |wc|
        csv << columns.map { |c| csv_value(wc,c) }
      end
    end
  end
  
  private
  
  def csv_value(wc,attr)
    case attr
    when :from, :to
      format_date wc.send(attr)
    when :intentions
      format_list wc.intentions, :code
    when :tags
      wc.tag_list
    when :capacity, :free_capacity, :free_capacity_females, :free_capacity_males
      [ 0, wc.send(attr) ].max
    when :no_more
      if wc.free_capacity <= 0
        'FULL'
      else
        format_list wc.no_more_countries, :name
      end
    else
      value = wc.send(attr)
    end
  end

end

