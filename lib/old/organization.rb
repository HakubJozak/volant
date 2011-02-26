class Old::Organization < Old::Gateway
  self.set_table_name 'organization'
  self.primary_key = 'or_id'


  def to_s
    "Organization #{or_id}"
  end

  def migrate
    @new = Organization.new
    #  or_id
    migrate_prefixed_fields 'or_', :name, :website, :fax, :mobile, :phone
    migrate_naming :or_id, :code
    migrate_naming :or_contactperson, :contact_person
    migrate_field :name, or_id if or_name.nil? or or_name.strip.empty?
    migrate_field :country, load_country(co_id)

    migrate_email :or_email1
    migrate_email :or_email2
    migrate_email :or_incomingemail
    migrate_email :or_outgoingemail

    migrate_unless_blank :address, "\n", or_address1, or_address2, or_postcode, or_zip
    migrate_network

    @new
  end

  private

  def migrate_network
    unless or_network.nil? or or_network == 'n/a'
      @new.networks << load_network(or_network)
    end
  end

  def migrate_email(field)
    address = send(field)

    unless address.nil? or address.strip.empty? or address == "''"
      contact = EmailContact.new(:name => address,
                                 :address => address,
                                 :active => (@new.emails.size == 0))
      contact.save!
      @new.emails << contact
      logger.info "Added email #{contact}"
    end
  end
end
