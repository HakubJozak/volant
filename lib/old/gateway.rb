module Old
  class Gateway < ActiveRecord::Base
    abstract_class = true
    establish_connection "old_models"

    private :delete, :destroy, :update

    def self.migrate_all(bypass_validation = false)
      self.find(:all).each do |old|
        begin
          logger.info "--------------------- Migrating #{self.to_s} -------------------"
          putc '.'
          $stdout.flush

          if (bypass_validation)
            raise "Save failed " unless old.migrate.save(false)
          else
            old.migrate.save!
          end

          logger.info "--------------------- Finished #{self.to_s}  -------------------"
        rescue
          logger.error "+++++++++++++++ Failed #{old} ++++++++++++++"
          logger.error "+++ #{$!.message}"
          puts
          p "#{old} +++ #{$!.message}"
        end
      end
    end

    protected



    def load_new_model(clazz, id )
      begin
        clazz.find_by_old_schema_key!(id)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound.new("Failed to load #{clazz} with ID key '#{id}'")
      end
    end

    # TODO - remove
    def load_workcamp(key)
      begin
        ::Workcamp.find_by_old_schema_key!(key)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound.new("Failed to load Workcamp with wc_id key '#{key}'")
      end
    end

    # TODO - remove
    def load_volunteer(key)
      begin
        Volunteer.find_by_old_schema_key!(key)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound.new("Failed to load Volunteer with me_id key '#{key}'")
      end
    end


    def load_network(name)
      begin
        Network.find_by_name!(or_network.strip)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound.new("Failed to load network named '#{or_network}'")
      end
    end


    def load_country(code)
      revolutions = { 'CS' => 'RS', 'SRB' => 'RS', 'VT' => 'VN', 'MNE' => 'ME' }
      code = revolutions[code] if revolutions.key?(code)
      begin
        Country.find_by_code!(code)
      rescue ActiveRecord::RecordNotFound
        raise ActiveRecord::RecordNotFound("Cannot find country #{code}")
      end
    end

    def migrate_prefixed_fields( prefix, *fields)
      fields.each do |field|
        field = field.to_s
        migrate_naming( prefix + field, field)
      end
    end

    def migrate_naming( old_field, new_field)
      raise "No target of the data migration" unless @new
      @new.send( "#{new_field}=", self.send(old_field))
      logger.info "#{old_field} -> #{new_field}: #{@new.send(new_field)}"
    end

    def migrate_field( new_field, value)
      raise "No target of the data migration" unless @new
      @new.send("#{new_field}=", value)
      logger.info "#{new_field}: #{@new.send(new_field)}"
    end

    def migrate_by_tag( tag_name)
      begin
        raise "No target of the data migration" unless @new
        tag = Tag.find_by_name!(tag_name)
        @new.tags << tag
        logger.info "Added tag '#{tag}' to #{@new.to_label}"
      rescue
        raise ActiveRecord::RecordNotFound.new("Failed to load tag '#{tag_name}'")
      end
    end

    # Migrates field to nil if the values array contains
    # only nils and empty strings. Otherwise joins non-empty
    # elements by delimiter and returns migrates field
    # to result.
    def migrate_unless_blank( field, delimiter, *values)
      if values.without_blanks!.empty?
        migrate_field field, nil
      else
        migrate_field field, values.join(delimiter)
      end
    end

  end
end

