require 'csv'

class Export::FridayList
  include CsvExporter
  
  def columns
    [ :code, :name, :from, :to, :minimal_age,
      :maximal_age, :intentions, :capacity, :free_capacity,
      :free_capacity_females, :free_capacity_males ]    
  end

  private
  
  def csv_value(wc,attr)
    case attr
    when :from, :to
      format_date wc.send(attr)
    when :intentions
      format_list wc.intentions
    when :tags
      wc.tag_list
    else
      value = wc.send(attr)
    end
  end

end

