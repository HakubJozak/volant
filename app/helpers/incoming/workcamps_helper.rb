module Incoming
  module WorkcampsHelper

    def list_row_class(wc)
      return 'running' if wc.running?
      return 'over' if wc.over?
    end

    def free_places_column(wc)
      "#{wc.free_places}/#{wc.capacity}"
    end

    def free_places_for_males_column(wc)
      "#{wc.free_places_for_males}/#{wc.capacity_males}"
    end

    def free_places_for_females_column(wc)
      "#{wc.free_places_for_females}/#{wc.capacity_females}"
    end

    def infosheets_column(wc)
      if wc.infosheets.empty?
        icon('add_infosheet', I18n.t('add_infosheet'), true)
      else
        count = wc.infosheets.count
        icon('infosheets', Infosheet.human_name(:count => count), true) + count.to_s
      end
    end

    def quick_contact_column(wc)
      icon = icon('email_go', I18n.t('quick_contact'), true)
      link = mail_to( wc.partners.collect { |p| p.email }.join(','), icon)
      phones = all(wc, :phone)

      result = all(wc, :contact_person) || ''
      result += '(' + phones.to_s + ')' unless phones.blank?
      result + link
    end

    def participants_count_column(wc)
      "#{wc.participants.not_cancelled.count}/#{wc.participants.count.to_s}"
    end

    def bookings_count_column(wc)
      wc.bookings.count
    end

    def bookings_column(wc)
      return icon('add_booking') if wc.bookings.empty?
      render_actors(wc.bookings)
    end

    def participants_column(wc)
      participants = wc.participants.not_cancelled

      if participants.empty?
        icon('add_participant')
      else
        sorted = participants.reject(&:cancelled).sort_by { |p| p.country.name }
        render_actors( sorted, :name => :lastname)
      end
    end

    def partners_contacts_column(wc)
      all(wc, :contact_person)
    end

    def partners_emails_column(wc)
      all(wc, :email)
    end

    def partners_phones_column(wc)
      all(wc, :phone)
    end

    def partners_address_column(wc)
      all(wc, :address)
    end

    protected

    def empty_or_collection( add_new, collection)
    end

    def render_actors(collection, options = {})
      labels = collection.map do |actor|
        label =  gender_icon(actor)
        country = actor.country.name if actor.country

        if options.key?(:name)
          label += "#{actor.send(options[:name]).upcase} (#{country})"
        else
          label += country if country
        end
      end

      compact_format(labels)
    end

    def all(wc, attr)
      wc.partners.map do |partner|
        partner.send(attr)
      end.compact.join(', ')
    end


    def compact_format(labels)
      labels.each_slice(2).collect do |slice|
        slice.join(',') + '</br>'
      end
    end

    def compact_table(labels)
      content_tag :table, :borders => 0 do
        labels.each_slice(2).collect do |slice|
          content_tag :tr do
            slice.collect do |label|
              content_tag(:td, label)
            end
          end
        end
      end
    end

  end
end
