class Old::Payment < Old::Gateway
  self.set_table_name 'payment'
  self.primary_key = 'pa_id'

  def to_s
    "Payment #{pa_id}"
  end

  def migrate
    @new = ::Payment.new

    # will be removed after the migration
    migrate_naming :pa_id, :old_schema_key

    migrate_prefixed_fields 'pa_', :received, :amount
    migrate_field :mean, mo_name.upcase

    desc =  "#{rp_name}"
    desc << " - #{ts_timescale}" unless 'Workcamp' == rp_name
    desc << ",#{pa_description}"
    desc << ",#{pa_returnreason}" if pa_returnreason
    migrate_field :description, desc

#    migrate_naming :pa_returnreason, :return_reason
#    migrate_naming :pa_returnedamount, :returned_amount
#    migrate_field :returned_date
    # extract date
#     if pa_returnreason =~ /(\d{1,2}).(\d{1,2}).(\d{4,4})/
#       Date.($2,$1,$3)
#     end

    @new
  end

end
