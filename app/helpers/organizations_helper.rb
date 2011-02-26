module OrganizationsHelper

  def name_with_link_column(record)
      website_column(record)
  end

  def networks_column(record)
    '-' and return unless record.networks
    record.networks.join if record.networks
  end

  def website_column(record)
    if record.website
      web = record.website.starts_with?('http://') ? record.website : "http://#{record.website}"
      link = link_to( record.name, web, :popup => true)
      icon('popup',t('txt.open_popup'), true) + link
    else
      record.name
    end
  end

  def phones_column(record)
    phones = [ record.phone, record.mobile ].compact
    return '-' if phones.empty?
    phones.join(',')
  end

end
