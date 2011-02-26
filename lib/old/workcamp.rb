class Old::Workcamp < Old::Gateway
  self.set_table_name 'workcamp'
  self.primary_key = 'wc_id'

  def to_s
    "Workcamp #{wc_id}"
  end

  def migrate
    @new = ::Workcamp.new

    migrate_prefixed_fields 'wc_', :name, :language,
                                   :begin, :end,
                                   :capacity, :accomodation,
                                   :notes, :area, :workdesc

    migrate_field :organization, load_organization(or_id)
    migrate_field :country, load_country(wc_country)
    migrate_field :description, [ wc_czdesc, wc_endesc ].compact.join("\n")

    # will be removed after the migration
    migrate_naming :wc_id, :old_schema_key

    migrate_naming :wc_fiyecode, :code
    migrate_naming :wc_freeplaces, :places
    migrate_naming :wc_freemale, :places_for_males
    migrate_naming :wc_freefemale, :places_for_females
    migrate_naming :wc_minage, :minimal_age
    migrate_naming :wc_maxage, :maximal_age

    # To avoid missing some workcamps due to wrong data
    migrate_field :name, "?" if @new.name.blank?
    migrate_field :code, "?" if @new.code.blank?

    migrate_by_tag('vegetarian') if wc_vegetarian
    migrate_by_tag('teenage') if wc_teenage
    migrate_by_tag('senior') if wc_senior
    migrate_by_tag('family') if wc_family

    @new.save!
    @new.intentions << WorkcampIntention.find_by_code!(wi_id) if wi_id
    @new.intentions << WorkcampIntention.find_by_code!(wi_id2) if wi_id2 and wi_id != wi_id2

    if @new.code.nil? or @new.name.nil?
      logger.warn "Ignoring workcamp #{self}!"
    end

    @new
  end

  private

  def load_organization(code)
    begin
      ::Organization.find_by_code!(code)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound.new("Failed to find Organization with code '#{code}'")
    end
  end
end
