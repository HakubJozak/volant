require 'csv'

class Export::WorkcampCsv
  include CsvExporter
  
  def columns
    [:id, :code, :name, :country_code, :country_name, :org_code,
     :org_name, :org_networks, :language, :from,:to, :duration,
     :capacity, :tags, :intentions, :places, :places_for_males,
     :places_for_females, :free_places, :free_places_for_males,
     :free_places_for_females, :free_capacity_males,
     :free_capacity_females, :free_capacity, :apply_forms_total,
     :apply_forms_accepted, :apply_forms_cancelled, :project_id,
     :minimal_age, :maximal_age, :area, :accomodation, :workdesc,
     :notes, :description, :created_at, :updated_at, :extra_fee,
     :extra_fee_currency, :region, :capacity_natives,
     :capacity_teenagers, :capacity_males, :capacity_females,
     :airport, :train, :publish_mode, :accepted_places,
     :accepted_places_males, :accepted_places_females,
     :asked_for_places, :asked_for_places_males,
     :asked_for_places_females, :type, :longitude, :latitude, :state,
     :requirements ] end

  protected

  def csv_header(attr)
    case attr
    when :apply_forms_total
      'Applications - Total'
    when :apply_forms_accepted
      'Applications - Accepted'
    when :apply_forms_cancelled
      'Applications - Cancelled'
    when :project_id
      'Project ID'
    else
      attr.to_s.humanize.capitalize
    end
  end

  def csv_value(wc,attr)
    case attr
    when :from, :to
      if val = wc.send(attr)
        I18n.l(val.to_date)
      else
        ''
      end
    when :country_name then wc.country.name
    when :country_code then wc.country.code
    when :org_name then wc.organization.name
    when :org_code then wc.organization.code
    when :apply_forms_total
      wc.apply_forms.count
    when :apply_forms_accepted
      wc.apply_forms.accepted.count
    when :apply_forms_cancelled
      wc.apply_forms.cancelled.count
    when :intentions
      format_list wc.intentions, :code
    when :org_networks
      format_list wc.organization.networks, :name
    when :tags
      wc.tag_list
    else
      value = wc.send(attr)
    end
  end

end
