class Old::Application < Old::Gateway
  self.set_table_name 'application'
  self.primary_key = 'ap_id'

   has_one :payment, :class_name => 'Old::Payment',
                     :foreign_key => 'ap_id',
                     :primary_key => 'ap_id'

   has_and_belongs_to_many :workcamps,
                           :class_name => "Old::Workcamp",
                           :foreign_key => 'ap_id',
                           :join_table => 'application_workcamp',
                           :association_foreign_key => 'wc_id'

  def to_s
    "Application '#{ap_id}'"
  end

  def migrate
    @new = ApplyForm.new

    migrate_prefixed_fields 'ap_', :motivation
    migrate_naming :ap_generalremarks, :general_remarks
    migrate_naming :ap_receiveddate, :created_at
    migrate_naming :ap_canceleddate, :cancelled
    migrate_field :volunteer, load_volunteer(me_id)
    @new.save!

    if payment
      new_payment = load_new_model ::Payment, payment.pa_id
      new_payment.apply_form = @new
      @new.fee = payment.pa_amount
      new_payment.save(false)
    end

    workcamps.each do |old_wc|
      old_assignment = Old::Assignment.find(:first, :conditions => [ "ap_id=? and wc_id=?", ap_id, old_wc.id ])
      assignment = WorkcampAssignment.new( :workcamp => load_workcamp(old_wc.id),
                                           :apply_form => @new,
                                           :accepted => old_assignment.aw_acceptdate,
                                           :rejected => old_assignment.aw_rejectdate,
                                           :order => old_assignment.aw_priority)
      assignment.save!
    end

#    ap_acceptdate timestamp without time zone,
#    ap_rejectdate timestamp without time zone,
#    ap_returnpayment boolean NOT NULL DEFAULT false,

#     ap_prefferedtime character varying(50),
#     ap_prefferedcountry character varying(50),
#     ap_prefferedintention text,
#     ap_resultby character varying(32),
#     ap_infosheetby character varying(32),
#     ap_infosheetsentdate timestamp without time zone,
#     ap_status character varying(32) DEFAULT 'NOT ASKED'::character varying,
#     ap_log text,
#     ap_status_detail text DEFAULT 'NOT PAID!'::text,

    @new
  end



end
